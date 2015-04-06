#!/bin/bash

#::::::::::::::::::::EXAMPLES::::::::::::::::::::

#rebind 
echo '
xkb_keymap {
	partial xkb_keycodes "evdev+aliases(qwerty)" {
		<IN> = 86;
		<OUT> = 82;
	};
	xkb_types  { include "complete"	};
	xkb_compat { include "complete" };
	partial alphanumeric_keys xkb_symbols "pc+us+br:2+inet(evdev)+group(alt_shift_toggle)+terminate(ctrl_alt_bksp)"	{
		key <IN> { [ XF86Launch1 ] };
		key <OUT> { [ XF86Launch2 ] };
	};
	xkb_geometry  { include "pc(pc105)"	};
};
' | xkbcomp - -i 11 $DISPLAY

#set power key to act as an END key (ASUS laptop):
#(You may also want to set in dconf-editor org.mate.power-manager.power-button = nothing)
sudo apt-get install acpi-fakekey
grep KEY_END /usr/share/acpi-support/key-constants
  KEY_END=107
sudo nano /etc/acpi/powerbtn-acpi-support.sh
  acpi_fakekey 107
  exit 0








############################################COPIED FROM rapoomap


#!/bin/bash
echo '
xkb_keymap {
	partial xkb_keycodes "evdev+aliases(qwerty)" {
		<IN> = 86;
		<OUT> = 82;
	};
	xkb_types  { include "complete"	};
	xkb_compat { include "complete" };
	partial alphanumeric_keys xkb_symbols "pc+us+br:2+inet(evdev)+group(alt_shift_toggle)+terminate(ctrl_alt_bksp)"	{
		key <IN> { [ XF86Launch1 ] };
		key <OUT> { [ XF86Launch2 ] };
	};
	xkb_geometry  { include "pc(pc105)"	};
};
' | xkbcomp - -i 11 $DISPLAY
exit 0

		key <IN> {
			type[group2]= "FOUR_LEVEL",
			symbols[Group1]= [               1,          exclam ],
			symbols[Group2]= [               1,          exclam,     onesuperior,      exclamdown ]
	};
		key <OUT> {
			type[group2]= "FOUR_LEVEL",
			symbols[Group1]= [               1,          exclam ],
			symbols[Group2]= [               1,          exclam,     onesuperior,      exclamdown ]
	};

xkb_keymap {
	xkb_keycodes  { include "evdev+aliases(qwerty)"	};
	xkb_types     { include "complete"	};
	xkb_compat    { include "complete"	};
	xkb_symbols   { include "pc+us+br:2+inet(evdev)+group(alt_shift_toggle)+terminate(ctrl_alt_bksp)"	};
	xkb_geometry  { include "pc(pc105)"	};
};

xkb_keymap {
	partial xkb_keycodes "mouse" {
		<MUP> = 254;
		<MDN> = 255;
	};
	xkb_types  { include "complete"	};
	xkb_compat { include "complete" };
	partial alphanumeric_keys xkb_symbols "pc+us+br:2+inet(evdev)+group(alt_shift_toggle)+terminate(ctrl_alt_bksp)"	{
		key <UPPER> { [ Help ] };
	};
	xkb_geometry  { include "pc(pc105)"	};
};

setxkbmap -option altwin:swap_lalt_lwin -print | xkbcomp - -i 11 $DISPLAY

exit 0


	partial modifier_keys
xkb_symbols "swap_l_shift_ctrl" {
		replace key <LCTL>    { [ Shift_L ] };
		replace key <LFSH> { [ Control_L ] };
};

	partial modifier_keys xkb_symbols "nocaps" {
		key <LWIN>    {    symbols[Group1]= [ Mod5 ] };
		modifier_map    Mod5 { <LWIN> };
	  };

xinput --list



	interpret Pointer_DblClick3+AnyOfOrNone(all) {
		action= PtrBtn(button=3,count=2);
	};
	
	
xkb_keymap {
	xkb_keycodes    { include "evdev+aliases(qwerty)"    };
	xkb_types        { include "complete"    };
	xkb_compatibility { include "complete" };
	#xkb_symbols    { include 
"pc+us+br:2+inet(evdev)+altwin(swap_lalt_lwin)+group(alt_shift_toggle)+terminate(ctrl_alt_bksp)" 
};
	xkb_geometry    { include "pc(pc105)"    };

	partial alphanumeric_keys xkb_symbols "dashes" {
		key <AE11> {
			symbols[Group2] = [ endash, emdash ]
		};
	};
};

xkbprint -label name $DISPLAY - | gv -orientation=seascape -

#get current:
setxkbmap -option altwin:swap_lalt_lwin -print | xkbcomp - -i 9 $DISPLAY
xkbcomp $DISPLAY xkb.dump


KeyRelease event, serial 40, synthetic NO, window 0x3e00001,
	root 0x82, subw 0x0, time 4838579, (691,143), root:(698,192),
	state 0x1, keycode 21 (keysym 0x2b, plus), same_screen YES,
	XLookupString gives 1 bytes: (2b) "+"
	XFilterEvent returns: False
