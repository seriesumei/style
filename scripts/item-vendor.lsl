// item_vendor - Sell/give inventory from this object
// May deliver either a single object or the contents

// v1 - Go!
// v2 - Add prev/next button handler
// v3 - Add texture cache
// v4 - Skip texture set, do $L0 price

// Buttons
// A prim named 'buttons' will collect clicks to be decoded into buttons

// Based on http://wiki.secondlife.com/wiki/Money and
// http://wiki.secondlife.com/wiki/Dispenser_Vendor

// Price
integer price = 0;

// Deliver all inventory
// TRUE = what it sounds like, except for this script
// FALSE - only the first object is delivered
integer DELIVER_ALL = TRUE;

// Filter for inventory item types
list inventory_types = [INVENTORY_LANDMARK, INVENTORY_NOTECARD, INVENTORY_OBJECT, INVENTORY_TEXTURE];

// Post transations to offsite log
integer LOG_TRANSACTIONS = TRUE;

// Log destination URL
string LOG_URL = "";

// Owner
key report = "";

//key report = NULL_KEY;

integer report_IM = FALSE;
integer report_HTTP = FALSE;

// Should CLICK_ACTION_PAY be set?
integer set_pay = TRUE;

// Show textures
integer show_texture = FALSE;

// Which side is the texture shown on?
integer DISPLAY_FACE = 4;  // ALL_SIDES;

// Which face to put the cache texture?
integer CACHE_FACE = 2;

// Display float text
integer SHOW_FLOAT = TRUE;

// Spew debug info
integer VERBOSE = FALSE;

// Recent buyers
list buyers = [];

// Vendor owner name
string owner_name;

// Vendor object name
string vendor_name;

// Which prim is named 'preview'?
integer preview_link = LINK_THIS;
integer text_link = LINK_THIS;
integer total_tex = 0;
integer counter = 0;
integer counter_next = -1;                      // -1 means do not display

debug(string txt) {
    if (VERBOSE) {
        llOwnerSay(txt);
    }
}

SetLinkText(integer linknum, string text, vector color, float alpha) {
    if (SHOW_FLOAT) {
        llSetLinkPrimitiveParamsFast(linknum, [PRIM_TEXT, text, color, alpha]);
    }
}

integer getLinkNum(string primName) {
    integer primCount = llGetNumberOfPrims();
    integer i;
    for (i=0; i<primCount+1; i++) {
        if (llGetLinkName(i) == primName) return i;
    }
    return FALSE;
}

string uUnix2StampStr( integer vIntDat ){
    if (vIntDat / 2145916800) {
        vIntDat = 2145916800 * (1 | vIntDat >> 31);
    }
    integer vIntYrs = 1970 + ((((vIntDat %= 126230400) >> 31) + vIntDat / 126230400) << 2);
    vIntDat -= 126230400 * (vIntDat >> 31);
    integer vIntDys = vIntDat / 86400;

    if (789 == vIntDys) {
        vIntYrs += 2;
        vIntDat = 2;
        vIntDys = 29;
    } else {
        vIntYrs += (vIntDys -= (vIntDys > 789)) / 365;
        vIntDys %= 365;
        vIntDys += vIntDat = 1;
        integer vIntTmp;
        while (vIntDys > (vIntTmp = (30 | (vIntDat & 1) ^ (vIntDat > 7)) - ((vIntDat == 2) << 1))) {
            ++vIntDat;
            vIntDys -= vIntTmp;
        }
    }
    string ret = (string)vIntYrs + "-";
    if (vIntDat < 10) ret += "0";
    ret += (string)vIntDat + "-";
    if (vIntDys < 10) ret += "0";
    ret += (string)vIntDys + " ";
    if (vIntDat % 86400 / 3600 < 10) ret += "0";
    ret += (string)(vIntDat % 86400 / 3600) + ":";
    if (vIntDat % 3600 / 60 < 10) ret += "0";
    ret += (string)(vIntDat % 3600 / 60) + ":";
    if (vIntDat % 60 < 10) ret += "0";
    ret += (string)(vIntDat % 60);
    return ret;
}

// Format a llGetTimestamp()
string FormatTime( string sTime ) {
    list l = llParseString2List( sTime, [ "T", "." ], [] );

    return llList2String( l, 0 ) + " " + llList2String( l, 1 ) + " UTC";
}

// Write to the remote wtmp logger
do_log(string agent, string msg) {
    if (report_IM && agent != NULL_KEY) {
        llInstantMessage(agent, msg);
    }
    if (report_HTTP) {
        key http_request_id;
        string body;

        body = "msg=" + llEscapeURL(msg);
        http_request_id = llHTTPRequest(
            LOG_URL,
            [
                HTTP_METHOD, "POST",
                HTTP_MIMETYPE,"application/x-www-form-urlencoded"
            ],
            body
        );
    }
}

give_items(key id) {
    string item_name;
    if (DELIVER_ALL) {
        list item_list;
        integer num_types = llGetListLength(inventory_types);
        integer j;
        integer k;
        integer type;
        integer typecount;
        string myname = llGetScriptName();

        for (j=0; j<num_types; j++) {
            // Loop through all inventory types we want
            type = llList2Integer(inventory_types, j);
            typecount = llGetInventoryNumber(type);
            if (typecount > 0) {
                for (k=0; k<typecount; k++) {
                    item_name = llGetInventoryName(type, k);
                    if (item_name != myname &&
                            llGetInventoryPermMask(item_name, MASK_OWNER) & PERM_COPY) {
                        // Don't give away this script
                        item_list += item_name;
//                        llGiveInventory(id, item_name);
                    }
                }
            }
        }
        if (item_list == []) {
            llInstantMessage(id, "No copiable items in inventory");
        } else {
            llInstantMessage(id, "Delivery of " + vendor_name + " has begun");
            llGiveInventoryList(id, vendor_name, item_list);
        }
    } else {
        item_name = llGetInventoryName(INVENTORY_OBJECT, 0);
        llInstantMessage(id, "Delivery of " + item_name + " has begun");
        llGiveInventory(id, item_name);
    }
}

deliver_items(key id, integer amount) {
    // Deliver items
    give_items(id);
    string buyer = llKey2Name(id);
    buyers += buyer;
    buyers += llGetUnixTime();
    if (LOG_TRANSACTIONS) {
        // do offsite logging here
        string timestamp = FormatTime(llGetTimestamp());
        do_log(report,
            timestamp + " " +
            owner_name + "," +
            vendor_name + "," +
            buyer + "," +
            (string)amount
        );
    }
}

set_texture(integer num) {
    debug("set_texture(): " + (string)num);
    if (num >= 0 && show_texture) {
        string current_texture = llGetInventoryName(INVENTORY_TEXTURE, num);
        llSetTexture(current_texture, DISPLAY_FACE);
        llSetLinkTexture(preview_link, current_texture, DISPLAY_FACE);
        if (price > 0) {
            SetLinkText(text_link, current_texture + "\n L$" + (string)price + " for all\n", <1,1,1>, 1);
        } else {
            SetLinkText(text_link, current_texture, <1,1,1>, 1);
        }
    }
    if (DISPLAY_FACE != CACHE_FACE && counter_next >= 0 && show_texture) {
        string next_texture = llGetInventoryName(INVENTORY_TEXTURE, counter_next);
        llSetTexture(next_texture, CACHE_FACE);
        llSetLinkTexture(preview_link, next_texture, CACHE_FACE);
    }
}

next() {
    counter++;
    if (counter >= total_tex) {
        counter=0;
    }
    counter_next = counter + 1;
    if (counter_next >= total_tex) {
        counter_next = 0;
    }
    set_texture(counter);
}

prev() {
    if (counter > 0) {
        counter--;
    } else {
        counter = total_tex - 1;
    }
    counter_next = counter - 1;
    if (counter_next < 0) {
        counter_next = total_tex - 1;
    }
    set_texture(counter);
}

default {
    state_entry() {
        // Reset all hover text
        SetLinkText(LINK_SET, "", <1,1,1>, 1);

        // Turn off pay options so no money can be received until we are ready
        llSetPayPrice(PAY_HIDE, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);

        // Request Debit Permissions from the owner so refunds can be given
//        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);

        owner_name = llGetUsername(llGetOwner());
        vendor_name = llGetObjectName();
        text_link = getLinkNum("button");
        if (preview_link != LINK_THIS) {
            preview_link = getLinkNum("preview");
        }
        total_tex = llGetInventoryNumber(INVENTORY_TEXTURE);
        next();
        if (price > 0) {
            SetLinkText(text_link, "L$" + (string)price + " \n", <1,1,1>, 1);
        } else {
            SetLinkText(text_link, "", <1,1,1>, 1);
        }

        // Do this here if we're running without PERMISSION_DEBIT
        llSetPayPrice(PAY_HIDE, [price ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        if (set_pay && price != 0)
            llSetClickAction(CLICK_ACTION_PAY);
    }

    on_rez(integer p) {
        llResetScript();
    }

    touch_start(integer num) {
        debug("enter touch_start state: " + (string)num);
        string link_name = llGetLinkName(llDetectedLinkNumber(0));
        vector pos = llDetectedTouchST(0);
        debug(" link: " + link_name);

        if (link_name == "button" ) {
            // handle 2 buttons
            integer bn = (integer)(pos.x * 2);
            if (bn == 0) {
                prev();
            }
            else if (bn == 1) {
                next();
            }
        }
        else {
            key id = llDetectedKey(0);
            if(id != llGetOwner())
                if (set_pay && price == 0)
                    deliver_items(id, 0);
                else
                    return;
            integer itra;
            llOwnerSay("===== BUYERS =====");
            for(itra=0; itra<llGetListLength(buyers); itra+=2) {
                llOwnerSay(llList2String(buyers, itra) + " @ " + uUnix2StampStr(llList2Integer(buyers, itra+1)));
            }
            llOwnerSay("===== =====");
        }
    }

    touch_end(integer num) {
        debug("enter touch_end state: " + (string)num);
    }

    money(key id, integer amount) {
        debug("entering money state: " + (string)id + ", " + (string)amount);

        // Some money has been received and has gone to this object's owner
        if (amount < price) {   // Customer has not paid enough
            llInstantMessage(id, "That's not enough money.");
//            llGiveMoney(id, amount);   // Refund the money they paid
            return;
        }
        if (amount > price) {   // Customer paid too much. Refund the excess
            integer change = amount - price;
            llInstantMessage(id, "You paid more than L$" + (string)price
                + "  your change is L$" + (string)change );
//            llGiveMoney(id, change);
        }
        if (amount == price) {
            deliver_items(id, amount);
        }
    }

    run_time_permissions(integer perm) {
        debug("entering run_permissions state: " + (string)perm);
        // If Debit permissions are granted, set up the pay price for this single-price vendor
        if(perm & PERMISSION_DEBIT) {
            llSetPayPrice(PAY_HIDE, [price ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
            llSetClickAction(CLICK_ACTION_PAY);
        }
    }

    transaction_result(key id, integer success, string data) {
        debug("enter transaction_result state: " + (string)id + ", " + (string)success + ", " + data);
    }
}
