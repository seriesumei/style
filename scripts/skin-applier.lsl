// SS Combo skin applier
// SPDX-License-Identifier: AGPL-3.0-or-later

// v1 - 04Jan2019 <seriesumei@avimail.org> - Initial combo applier
// v2 - 13Jan2019 <seriesumei@avimail.org> - Rework for Omega 4.41+
// v2.rw - 23Jun2019 <seriesumei@avimail.org> - Robin Wood applier version

// Textures - Use the Omega structure and pick out what we need for Ruth
// The Omega notecard should have button names 'upper', 'h_<color>_<makeup>'
// (head) and 'l_<color>_<makeup>' (lower).

// Buttons - There are three skin button types, they are prefixed with
//           'c_' (color), 'm_' (makeup) and 'l_' (lower).

// Select the applier to activate
integer DO_RUTH = FALSE;
integer DO_OMEGA = TRUE;

vector off_color = <1.0, 1.0, 1.0>;
vector on_color = <0.3, 0.3, 0.3>;

integer channel;
integer app_id = 20181024;

// HUD Texture States
string state_color = "black";
string state_makeup = "natural";
string state_lower = "princess";

// To simplify the creator's life we read Omega-compatible notecards
string NOTECARD = "!MASTER_CONFIG";
key notecard_qid;
list config;
integer line;
integer reading_notecard = FALSE;

// HUD Positioning offsets
float bottom_offset = 0.08;
float left_offset = 0.00;
float right_offset = 0.00;
float top_offset = -0.08;
integer last_attach = 0;

// Memory limit
integer MEM_LIMIT = 32000;

integer VERBOSE = FALSE;

integer keyapp2chan() {
    return 0x80000000 | ((integer)("0x" + (string)llGetOwner()) ^ app_id);
}

log(string msg) {
    if (VERBOSE) {
        llOwnerSay(msg);
    }
}

vector get_size() {
    return llList2Vector(llGetPrimitiveParams([PRIM_SIZE]), 0);
}

adjust_pos() {
    integer current_attach = llGetAttached();

    // See if attachpoint has changed
    if ((current_attach > 0 && current_attach != last_attach) ||
            (last_attach == 0)) {
        vector size = get_size();

        // Nasty if else block
        if (current_attach == ATTACH_HUD_TOP_LEFT) {
            llSetPos(<0.0, left_offset - size.y / 2, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_TOP_CENTER) {
            llSetPos(<0.0, 0.0, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_TOP_RIGHT) {
            llSetPos(<0.0, right_offset + size.y / 2, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM_LEFT) {
            llSetPos(<0.0, left_offset - size.y / 2, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM) {
            llSetPos(<0.0, 0.0, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM_RIGHT) {
            llSetPos(<0.0, right_offset + size.y / 2, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_CENTER_1) {
        }
        else if (current_attach == ATTACH_HUD_CENTER_2) {
        }
        last_attach = current_attach;
    }
}

send_to_ruth(string msg) {
    llSay(channel, msg);
    log("Ruth: " + msg);
}

apply_texture(string button) {
    if (DO_RUTH) {
        log("button="+button);
//        log("config len: "+(string)llGetListLength(config));

        integer i;
        for (; i < llGetListLength(config); ++i) {
            list d = llParseStringKeepNulls(llList2String(config, i), ["|"], []);
            if (llList2String(d, 0) == button) {
                if (llList2String(d, 1) == "omegaHead") {
                    send_to_ruth("TEXTURE,head," + llList2String(d, 2));
                }
                if (llList2String(d, 1) == "lolasSkin") {
                    send_to_ruth("TEXTURE,upper," + llList2String(d, 2));
                }
                if (llList2String(d, 1) == "skin") {
                    send_to_ruth("TEXTURE,lower," + llList2String(d, 2));
                }
            }
        }
    }

    if (DO_OMEGA) {
        llMessageLinked(LINK_THIS, 411, button + "|apply", "");
    }
}

// Convert face + position to a button name for 3 choices
string map_button_3(integer face, integer x) {
    string ret;
    if (face == 0 && x == 0) {
        ret = "1";
    }
    else if (face == 0 && x == 1) {
        ret = "2";
    }
    else if (face == 2) {
        ret = "3";
    }
    else if (face == 4) {
        ret = "1";
    }
    return ret;
}

// Convert face + position to a button name for 4 choices
string map_button_4(integer face, integer x) {
    string ret;
    if (face == 0 && x == 0) {
        ret = "1";
    }
    else if (face == 0 && x == 1) {
        ret = "2";
    }
    else if (face == 2 && x == 0) {
        ret = "3";
    }
    else if (face == 2 && x == 1) {
        ret = "4";
    }
    else if (face == 4) {
        ret = "1";
    }
    return ret;
}

init() {
    // Initialize channel
    channel = keyapp2chan();

    // Initialize attach state
    last_attach = llGetAttached();

    // Set up memory constraints
    llSetMemoryLimit(MEM_LIMIT);

    reading_notecard = FALSE;
    if (DO_RUTH) {
        log("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
        llOwnerSay("reading notecard named '" + NOTECARD + "'.");
        line = 0;
        config = [];
        reading_notecard = TRUE;
        notecard_qid = llGetNotecardLine(NOTECARD, line);
    } else {
        llOwnerSay("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
    }
}

default {
    state_entry() {
        init();
    }

    dataserver(key query_id, string data) {
        if (query_id == notecard_qid) {
            if (data != EOF) {
                data = llStringTrim(data, STRING_TRIM_HEAD);
                if (data != "" && llSubStringIndex(data, "*") != 0) {
                    if (llSubStringIndex(data, "|") >= 0) {
                        // Only save lines that might be valid
                        config += data;
                    }
                    else if (llSubStringIndex(data, "mode:") >= 0) {
                        // process mode line
                        string mode = llGetSubString(data, 5, -1);
                        if (mode == "loud") {
                            VERBOSE = TRUE;
                        }
                        else if (mode = "autodelete") {
                            // remove notecard here someday
                        }
                    }
                }
                notecard_qid = llGetNotecardLine(NOTECARD, ++line);
            } else {
                reading_notecard = FALSE;
                llOwnerSay("Finished reading notecard " + NOTECARD);
                llOwnerSay("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
            }
        }
    }

    touch_start(integer total_number) {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        vector pos = llDetectedTouchST(0);
        list d = llGetLinkPrimitiveParams(link, [PRIM_NAME, PRIM_DESC]);
        string name = llList2String(d, 0);
        string desc = llList2String(d, 1);
        log("Touched: " + name + ", " + desc);

        if (reading_notecard) {
            llOwnerSay("Reading notecard, please wait...");
            return;
        }

        // Make the state change according to the button
        if (llGetSubString(name, 0, 1) == "c_") {
            state_color = llGetSubString(name, 2, -1);
        }
        if (llGetSubString(name, 0, 1) == "m_") {
            state_makeup = llGetSubString(name, 2, -1);
        }
        if (llGetSubString(name, 0, 1) == "l_") {
            state_lower = llGetSubString(name, 2, -1);
        }

        // This is particular to how Omega arranges its regions
        // we do them in stages to reduce the memory and combinations
        // required in the notecard.
        apply_texture("h_" + state_color + "_" + state_makeup);
        apply_texture("upper");
        apply_texture("l_" + state_color + "_" + state_lower);
        log("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
    }

    attach(key id) {
        if (id == NULL_KEY) {
            // Nothing to do on detach?
        } else {
            // Fix up our location
            adjust_pos();
        }
    }

    changed(integer change) {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            init();
    }
}
