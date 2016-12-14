// give all items in a prim to the owner, as folder (with the name of the prim)
// Ezhar Fairlight <efairlight@gmail.com>

// user-friendly additions by Mechanique Thirty (egypt@urnash.com)
// Script adjusted to run faster by Strife Onizuka.

// Rearranged and hover text added by seriesumei@avimail.org
// v2 - add random object give

// set TRUE to restrict to owner
integer OWNER_ONLY = FALSE;

// set TRUE to give one random object instead of all objects
integer RANDOM_OBJECT = FALSE;

vector COLOR = <1.0, 0.8, 1.0>;
string PREFIX = "";

default {

    state_entry() {
        llSetText(llGetObjectName(), COLOR, 1);
    }

    touch_start(integer total_number) {

        list        inventory;
        string      name;
        integer     num = llGetInventoryNumber(INVENTORY_ALL);
        string      text = llGetObjectName() + " is unpacking...\n";
        integer     i;
        key         user;

        if (OWNER_ONLY) {
            // Allow anyone to use
            user = llDetectedKey(0);
        } else {
            // Restrict to owner
            user = llGetOwner();
        }

        llSetAlpha(0, 0);

        for (i = 0; i < num; ++i) {
            name = llGetInventoryName(INVENTORY_ALL, i);
            if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY)
                inventory += name;
            else
                llOwnerSay("Cannot give asset \""+name+"\", owner lacks copy permission");
// Uncomment this to use progress bar in hover text
//            llSetText(text + (string)((integer)(((i + 1.0) / num) * 100))+ "%", <1, 1, 1>, 1.0);
        }

        if (RANDOM_OBJECT) {
            list rnd_inv = llListRandomize(inventory, 1);
            // take the second item of the randomized list
            inventory = [llList2String(rnd_inv, 1)];
        }

        //chew off the end off the text message.
        text = PREFIX + llGetObjectName();

        //we don't want to give them this script
        i = llListFindList(inventory, [llGetScriptName()]);
        if(~i)//if this script isn't found then we shouldn't try and remove it
            inventory = llDeleteSubList(inventory, i, i);

        if (llGetListLength(inventory) < 1) llSay(0, "No items to offer."); else
        {
            llGiveInventoryList(user, text, inventory);
// Uncomment this to use progress bar in hover text
//            llSetText("",<1,1,1>,1);
            name = "Your new items can be found in your inventory, in a folder called '"+ text +"'.";
            if(user == llGetOwner())
                llOwnerSay(name);
            else
                llInstantMessage(user, name);
        }
        llSetText(llGetObjectName(), COLOR, 1);
    }
}
