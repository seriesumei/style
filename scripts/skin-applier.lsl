// SS Combo skin applier
// SPDX-License-Identifier: AGPL-3.0-or-later

// v1 - 04Jan2019 <seriesumei@avimail.org> - Initial combo applier

// Textures - Use the Omega structure and pick out what we need for Ruth

// Select the applier to activate
integer DO_RUTH = TRUE;
integer DO_OMEGA = FALSE;

// The list stride is 8 for the nnumber of Omega texture slots
integer num_tex = 8;

// Set these to the full-perm texture UUIDs
// omega: head, neck, breast, upper, lower, hand, feet, nipple
list tex_1 = [
    // Female 1 - Linda Kellie
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "0be30f69-6c17-358e-3419-38aeb92540ae",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "0be30f69-6c17-358e-3419-38aeb92540ae",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5"
];

list tex_2 = [
    // Female 2 - Linda Kellie
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "63d9c443-e815-070b-18e7-5db998af28e5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "63d9c443-e815-070b-18e7-5db998af28e5",
    "83172ffd-2431-e629-7b19-f67e689288b5"
];

vector off_color = <1.0, 1.0, 1.0>;
vector on_color = <0.3, 0.3, 0.3>;

integer channel;
integer app_id = 20181024;

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
    log("Ruth: " + msg);
    llSay(channel, msg);
}

send_to_omega(string msg) {
    log("Omega: " + msg);
    llMessageLinked(LINK_THIS, -1, msg, "");
}

apply_texture(list tex) {
    if (DO_RUTH) {
        send_to_ruth("TEXTURE,head," + llList2String(tex, 0));
        send_to_ruth("TEXTURE,upper," + llList2String(tex, 3));
        send_to_ruth("TEXTURE,lower," + llList2String(tex, 4));
    }

    if (DO_OMEGA) {
        send_to_omega("Head" + ":" + llList2String(tex, 0));
        send_to_omega("Neck" + ":" +  llList2String(tex, 1));
        send_to_omega("Breast" + ":" +  llList2String(tex, 2));
        send_to_omega("Upper" + ":" +  llList2String(tex, 3));
        send_to_omega("Lower" + ":" +  llList2String(tex, 4));
        send_to_omega("Hand" + ":" +  llList2String(tex, 5));
        send_to_omega("Feet" + ":" +  llList2String(tex, 6));
        send_to_omega("Nipple" + ":" +  llList2String(tex, 7));
    }
}

default {
    state_entry() {
        // Initialize channel
        channel = keyapp2chan();

        // Initialize attach state
        last_attach = llGetAttached();

        // Set up memory constraints
        llSetMemoryLimit(MEM_LIMIT);
        log("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
    }

    touch_start(integer total_number) {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        vector pos = llDetectedTouchST(0);
        string name = llGetLinkName(link);

        llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, on_color, 1.0]);
        if (name == "button1") {
            // 2x2 button
            integer bx = (integer)(pos.x * 2);
            integer by = (integer)(pos.y * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
        }
        else if (name == "button2") {
            // single button
            if (face == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
        llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, off_color, 1.0]);
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
}
