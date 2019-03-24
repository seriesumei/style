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
    // Female 1 shaved
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "0be30f69-6c17-358e-3419-38aeb92540ae",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "0be30f69-6c17-358e-3419-38aeb92540ae",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",

    // Female 1 bushy
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "24b7eae1-403f-7346-b899-d34dde0f3d01",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "24b7eae1-403f-7346-b899-d34dde0f3d01",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",

    // Female 1 landing strip
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "acadebf3-c9d7-5f3a-320f-ed210d901699",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "acadebf3-c9d7-5f3a-320f-ed210d901699",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",

    // Female 1 extra bushy
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "aebcf034-b7b5-c682-5877-9e6037db9799",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "3022144c-087a-1f0a-b6a3-36142cdf4b14",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5",
    "3022144c-087a-1f0a-b6a3-36142cdf4b14",
    "64b3d1a1-1efb-99c8-e287-cff42f48c6a5"
];

list tex_2 = [
    // Female 2 shaved
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "63d9c443-e815-070b-18e7-5db998af28e5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "63d9c443-e815-070b-18e7-5db998af28e5",
    "83172ffd-2431-e629-7b19-f67e689288b5",

    // Female 2 bushy
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "ae90997b-5fd9-b047-acca-ac4e7adb3fa1",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "ae90997b-5fd9-b047-acca-ac4e7adb3fa1",
    "83172ffd-2431-e629-7b19-f67e689288b5",

    // Female 2 landing strip
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "b0d6e00c-f14e-46aa-5ad8-7989e7b8ac53",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "b0d6e00c-f14e-46aa-5ad8-7989e7b8ac53",
    "83172ffd-2431-e629-7b19-f67e689288b5",

    // Female 2 extra bushy
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "c923f154-c1bf-ae41-d3f8-c1de78f44ca0",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "a5c97deb-dafd-385e-2883-e698e2ebac3c",
    "83172ffd-2431-e629-7b19-f67e689288b5",
    "a5c97deb-dafd-385e-2883-e698e2ebac3c",
    "83172ffd-2431-e629-7b19-f67e689288b5"
];

list tex_3 = [
    // Female 3 shaved
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "7ea4efe7-c0f9-3c56-3326-c87e5a2f19c3",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "7ea4efe7-c0f9-3c56-3326-c87e5a2f19c3",
    "a276d547-8de0-8326-c603-49cbcc509cb8",

    // Female 3 bushy
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "b9690079-5734-c01b-5bc2-95c2e41c375f",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "b9690079-5734-c01b-5bc2-95c2e41c375f",
    "a276d547-8de0-8326-c603-49cbcc509cb8",

    // Female 3 landing strip
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "44d47200-8f4e-1220-2b74-2be1ee8e9ac5",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "8421cf09-bb4a-9ba5-8087-911746b00ced",
    "a276d547-8de0-8326-c603-49cbcc509cb8",
    "8421cf09-bb4a-9ba5-8087-911746b00ced",
    "a276d547-8de0-8326-c603-49cbcc509cb8"
];

list tex_4 = [
    // Female 4 shaved
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "7ea4efe7-c0f9-3c56-3326-c87e5a2f19c3",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "7ea4efe7-c0f9-3c56-3326-c87e5a2f19c3",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",

    // Female 4 bushy
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "a656222d-73e2-2663-5472-8ccd85d3adf5",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "a656222d-73e2-2663-5472-8ccd85d3adf5",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",

    // Female 4 landing strip
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "096ee6f2-717b-fec3-4ed8-39f636fec964",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "225c1668-b82d-aea1-40fb-1e421f37ab11",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a",
    "225c1668-b82d-aea1-40fb-1e421f37ab11",
    "a3243796-87eb-78a7-cbe1-15a29c78ca5a"
];

list tex_5 = [
    // Female 5 shaved
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "68f829d1-d736-269b-1577-e8b768795638",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "68f829d1-d736-269b-1577-e8b768795638",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",

    // Female 5 bushy
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "b2b1a848-377b-031c-d5c4-fd30b49c4fb3",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "b2b1a848-377b-031c-d5c4-fd30b49c4fb3",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",

    // Female 5 landing strip
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "5dd60e66-f8a3-6dcb-50c6-23e52939e86b",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "d2062972-ee1b-4826-d35e-e00eb5b55320",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a",
    "d2062972-ee1b-4826-d35e-e00eb5b55320",
    "e9af3504-70e5-80c7-d332-7fc3272ab23a"
];

list tex_6 = [
    // Female 6 shaved
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "9ef029ff-65fc-76f4-432d-f013c4a593c5",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "9ef029ff-65fc-76f4-432d-f013c4a593c5",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",

    // Female 6 bushy
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "8e83a25f-bef9-2724-943f-1aecbc79d3b4",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "8e83a25f-bef9-2724-943f-1aecbc79d3b4",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",

    // Female 6 landing strip
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "374ec125-5968-33a9-eca3-c9b9ee3cb262",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "365df245-4b69-8e18-a315-bc6420db5798",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885",
    "365df245-4b69-8e18-a315-bc6420db5798",
    "cc92325a-aa11-d6c1-6c46-db2ea4a56885"
];

list tex_7 = [
    // Female 7 shaved
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "79f1c337-8549-5d4e-cba8-842512add3b8",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "79f1c337-8549-5d4e-cba8-842512add3b8",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",

    // Female 7 bushy
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "1a15673d-8d0a-1fa3-a17a-6b284023dcce",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "1a15673d-8d0a-1fa3-a17a-6b284023dcce",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",

    // Female 7 shaved
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "31b85c7e-5294-76ec-b83b-854581240e74",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "d2094f99-48f0-0aab-8b50-eebd09da5fca",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446",
    "d2094f99-48f0-0aab-8b50-eebd09da5fca",
    "c40b8624-8cd0-d877-4fab-ce96e31ae446"
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
//        log("Free memory " + (string)llGetFreeMemory() + "  Limit: " + (string)MEM_LIMIT);
    }

    touch_start(integer total_number) {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        vector pos = llDetectedTouchST(0);
        string name = llGetLinkName(link);

        llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, on_color, 1.0]);
        if (name == "button1") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
            else if (face == 2 && bx == 0) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
            else if (face == 2 && bx == 1) {
                integer i = ((4 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_1, i, i+num_tex-1));
            }
        }
        else if (name == "button2") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
            else if (face == 2 && bx == 0) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
            else if (face == 2 && bx == 1) {
                integer i = ((4 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_2, i, i+num_tex-1));
            }
        }
        else if (name == "button3") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_3, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_3, i, i+num_tex-1));
            }
            else if (face == 2) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_3, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_3, i, i+num_tex-1));
            }
        }
        else if (name == "button4") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_4, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_4, i, i+num_tex-1));
            }
            else if (face == 2) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_4, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_4, i, i+num_tex-1));
            }
        }
        else if (name == "button5") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_5, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_5, i, i+num_tex-1));
            }
            else if (face == 2) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_5, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_5, i, i+num_tex-1));
            }
        }
        else if (name == "button6") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_6, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_6, i, i+num_tex-1));
            }
            else if (face == 2) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_6, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_6, i, i+num_tex-1));
            }
        }
        else if (name == "button7") {
            integer bx = (integer)(pos.x * 2);
            if (face == 0 && bx == 0) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_7, i, i+num_tex-1));
            }
            else if (face == 0 && bx == 1) {
                integer i = ((2 - 1) * num_tex);
                apply_texture(llList2List(tex_7, i, i+num_tex-1));
            }
            else if (face == 2) {
                integer i = ((3 - 1) * num_tex);
                apply_texture(llList2List(tex_7, i, i+num_tex-1));
            }
            else if (face == 4) {
                integer i = ((1 - 1) * num_tex);
                apply_texture(llList2List(tex_7, i, i+num_tex-1));
            }
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
