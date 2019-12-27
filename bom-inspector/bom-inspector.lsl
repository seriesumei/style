// SS BoM Inspector
// SPDX-License-Identifier: AGPL-3.0-or-later

// v1 - 27Dec2019 <seriesumei@avimail.org> - Initial release

// Wear as a HUD and it will display the baked textures for each of the 11
// BoM channels.  Click on a texture to see an enlarged version of it in a
// pop-up.  Click the pop-up to make it go away.

// As currently written the touch logic expects touch events
// from 3 mesh buttons ('b1' - 'b3') with 5 faces each and a preview
// prim named 'preview' to display a texture on face 4.

// Map the texture button faces in order
// The mesh 5x buttons I used do not have the faces in consecutive
// order, this lets us fix that.
list bom_tex = [
    IMG_USE_BAKED_LOWER,
    IMG_USE_BAKED_HEAD,
    IMG_USE_BAKED_UPPER,
    IMG_USE_BAKED_LEFTARM,
    IMG_USE_BAKED_LEFTLEG,
    IMG_USE_BAKED_HAIR,
    IMG_USE_BAKED_EYES,
    IMG_USE_BAKED_SKIRT,
    IMG_USE_BAKED_AUX1,
    IMG_USE_BAKED_AUX2,
    TEXTURE_TRANSPARENT,
    IMG_USE_BAKED_AUX3,
    TEXTURE_TRANSPARENT,
    TEXTURE_TRANSPARENT,
    TEXTURE_TRANSPARENT
];

vector preview_pos_top = <0.00000, 0.00000, -0.15000>;
vector preview_pos_bottom = <0.00000, 0.00000, 0.15000>;
integer preview;

// HUD Positioning offsets
float bottom_offset = 0.03;
float left_offset = -0.01;
float right_offset = 0.01;
float top_offset = -0.03;
integer last_attach = 0;

// Memory limit
integer MEM_LIMIT = 32000;

integer VERBOSE = TRUE;

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
        vector preview_pos = preview_pos_bottom;

        // Nasty if else block
        if (current_attach == ATTACH_HUD_TOP_LEFT) {
            llSetPos(<0.0, left_offset - size.y / 2, top_offset - size.z / 2>);
            preview_pos = preview_pos_top;
        }
        else if (current_attach == ATTACH_HUD_TOP_CENTER) {
            llSetPos(<0.0, 0.0, top_offset - size.z / 2>);
            preview_pos = preview_pos_top;
        }
        else if (current_attach == ATTACH_HUD_TOP_RIGHT) {
            llSetPos(<0.0, right_offset + size.y / 2, top_offset - size.z / 2>);
            preview_pos = preview_pos_top;
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

        // Move preview prim
        llSetLinkPrimitiveParamsFast(preview, [PRIM_POS_LOCAL, preview_pos]);
    }
}

init() {
    integer i = 0;
    for (; i < llGetNumberOfPrims() + 1; ++i) {
        list p = llGetLinkPrimitiveParams(i, [PRIM_NAME, PRIM_DESC]);
        if (llToLower(llList2String(p, 0)) == "preview") {
            preview = i;
        }
    }

    // Initialize attach state
    last_attach = llGetAttached();

    // Set up memory constraints
//    llSetMemoryLimit(MEM_LIMIT);
//    llOwnerSay("Memory: used="+(string)llGetUsedMemory()+" free="+(string)llGetFreeMemory());
}

default {
    state_entry() {
        init();
    }

    touch_start(integer total_number) {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        vector pos = llDetectedTouchST(0);
        list d = llGetLinkPrimitiveParams(link, [PRIM_NAME, PRIM_DESC]);
        string name = llList2String(d, 0);
        string desc = llList2String(d, 1);
        log("Touched: " + name + ", " + desc);

        integer button;
        // Make the state change according to the button
        if (link == preview) {
            // Turn off preview
            llSetLinkTexture(preview, TEXTURE_TRANSPARENT, ALL_SIDES);
        }
        else {
            if (name == "b1") {
                button = face;
            }
            else if (name == "b2") {
                button = face + 5;
            }
            else if (name == "b3") {
                button = face + 10;
            }

            log("button: " + (string)button);
            log("tex: " + llList2String(bom_tex, button));
            llSetLinkTexture(preview, llList2String(bom_tex, button), 4);
        }

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
