// give all items in a prim to the owner, as folder (with the name of the prim)
// Ezhar Fairlight <efairlight@gmail.com>

// user-friendly additions by Mechanique Thirty (egypt@urnash.com)
// Script adjusted to run faster by Strife Onizuka.

// Rearranged and hover text added by seriesumei@avimail.org
// v2 - add random object give
// v3 - fix owner check
// v4 - detect attachment and offer inventory

// set TRUE to restrict to owner
integer OWNER_ONLY = FALSE;

// set TRUE to give one random object instead of all objects
integer RANDOM_OBJECT = FALSE;

// set to show progress bar in hover text
integer PROGRESS_BAR = FALSE;

vector COLOR = <1.0, 0.8, 1.0>;
string PREFIX = "";

// Do object inventory delivery to avatar inventory
deliver_inventory(key user) {
    list inventory;
    string name;
    integer num = llGetInventoryNumber(INVENTORY_ALL);
    string text = llGetObjectName() + " is unpacking...\n";
    integer i = 0;

    for (; i < num; ++i) {
        name = llGetInventoryName(INVENTORY_ALL, i);
        if (llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY)
            inventory += name;
        else
            llOwnerSay(name + "can not be copied");

        if (PROGRESS_BAR)
            llSetText(text + (string)((integer)(((i + 1.0) / num) * 100))+ "%", <1, 1, 1>, 1.0);
    }

    if (RANDOM_OBJECT) {
        list rnd_inv = llListRandomize(inventory, 1);
        // take the second item of the randomized list
        inventory = [llList2String(rnd_inv, 1)];
    }

    // chew off the end off the text message.
    text = PREFIX + llGetObjectName();

    // we don't want to give them this script
    i = llListFindList(inventory, [llGetScriptName()]);
    if (~i)
        // if this script isn't found then we shouldn't try and remove it
        inventory = llDeleteSubList(inventory, i, i);

    if (llGetListLength(inventory) < 1) {
        llOwnerSay("No items to offer.");
    } else {
        llGiveInventoryList(user, text, inventory);
        if (PROGRESS_BAR)
            llSetText("", <1,1,1> ,1);
        name = "Your new items are in your inventory in a folder called '"+ text +"'";
        if (user == llGetOwner())
            llOwnerSay(name);
        else
            llInstantMessage(user, name);
    }
    llSetText(llGetObjectName(), COLOR, 1);
}

default {

    state_entry() {
        llSetText(llGetObjectName(), COLOR, 1);
    }

    touch_start(integer total_number) {
        key owner;
        key user = llDetectedKey(0);

        if (OWNER_ONLY) {
            // Restrict to owner
            owner = llGetOwner();
            if (user != owner) {
                // Don't deliver to anyone else
                llInstantMessage(user, "Delivery is restricted to the owner");
                return;
            }
        }
        deliver_inventory(user);
    }

    attach(key id) {
        if (id != NULL_KEY) {
            // attach
            deliver_inventory(id);
        } else {
            if (llGetAttached() == 0) {
                // detach
            } else {
                // left over event from prior detach
            }
        }
    }
}
