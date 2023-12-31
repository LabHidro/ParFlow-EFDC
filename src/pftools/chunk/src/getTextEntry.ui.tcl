#!/usr/local/bin/wish
# interface generated by SpecTcl version 1.1 from C:/Program Files/SpecTcl1.1/demo/getTextEntry.ui
#   root     is the parent window for this user interface

proc getTextEntry_ui {root n_text} {

	# this treats "." as a special case

	if {$root == "."} {
	    set base ""
	} else {
	    set base $root
	}
    
	frame $base.frame#2

	frame $base.frame#3 \
		-borderwidth 2 \
		-relief groove

	frame $base.frame#4

	frame $base.frame#1

	label $base.label#1 \
		-text Text:

	entry $base.entryText \
		-textvariable text \
		-width 40

	label $base.label#2 \
		-text Size:

	entry $base.entryTextSize \
		-textvariable text_size \
		-width 2

	label $base.label#4 \
		-text Font:

	radiobutton $base.radiobutton#1 \
		-text Helvetica \
		-value helvetica \
		-variable text_font

	radiobutton $base.radiobutton#2 \
		-text Roman \
		-value roman \
		-variable text_font

	checkbutton $base.checkbuttonTextStyleBold \
		-onvalue bold \
		-text bold \
		-variable textStyle

	checkbutton $base.checkbuttonTextStyleItalic \
		-onvalue italic \
		-text italic \
		-variable text_style_italic

	label $base.label#5 \
		-text Translate:

	label $base.label#6 \
		-text x

	entry $base.entryTextTranslateX \
		-textvariable text_translate_x \
		-width 6

	label $base.label#7 \
		-text y

	entry $base.entryTextTranslateY \
		-textvariable text_translate_y \
		-width 6


	# Geometry management

	grid $base.frame#2 -in $root	-row 2 -column 1 
	grid $base.frame#3 -in $root	-row 3 -column 1 
	grid $base.frame#4 -in $root	-row 4 -column 1 
	grid $base.frame#1 -in $root	-row 1 -column 1 
	grid $base.label#1 -in $base.frame#1	-row 1 -column 1 
	grid $base.entryText -in $base.frame#1	-row 1 -column 2 
	grid $base.label#2 -in $base.frame#2	-row 1 -column 1  \
		-sticky e
	grid $base.entryTextSize -in $base.frame#2	-row 1 -column 2 
	grid $base.label#4 -in $base.frame#3	-row 1 -column 1 
	grid $base.radiobutton#1 -in $base.frame#3	-row 1 -column 2 
	grid $base.radiobutton#2 -in $base.frame#3	-row 1 -column 3 
	grid $base.checkbuttonTextStyleBold -in $base.frame#3	-row 1 -column 4 
	grid $base.checkbuttonTextStyleItalic -in $base.frame#3	-row 1 -column 5 
	grid $base.label#5 -in $base.frame#4	-row 1 -column 1 
	grid $base.label#6 -in $base.frame#4	-row 1 -column 2  \
		-sticky e
	grid $base.entryTextTranslateX -in $base.frame#4	-row 1 -column 3 
	grid $base.label#7 -in $base.frame#4	-row 1 -column 4  \
		-sticky e
	grid $base.entryTextTranslateY -in $base.frame#4	-row 1 -column 5 

	# Resize behavior management

	grid rowconfigure $base.frame#2 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#2 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#2 2 -weight 0 -minsize 30
	grid columnconfigure $base.frame#2 3 -weight 0 -minsize 30

	grid rowconfigure $base.frame#3 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#3 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#3 2 -weight 0 -minsize 30
	grid columnconfigure $base.frame#3 3 -weight 0 -minsize 30
	grid columnconfigure $base.frame#3 4 -weight 0 -minsize 30
	grid columnconfigure $base.frame#3 5 -weight 0 -minsize 30

	grid rowconfigure $root 1 -weight 0 -minsize 30
	grid rowconfigure $root 2 -weight 0 -minsize 30
	grid rowconfigure $root 3 -weight 0 -minsize 30
	grid rowconfigure $root 4 -weight 0 -minsize 30
	grid columnconfigure $root 1 -weight 0 -minsize 30

	grid rowconfigure $base.frame#4 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#4 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#4 2 -weight 0 -minsize 30
	grid columnconfigure $base.frame#4 3 -weight 0 -minsize 30
	grid columnconfigure $base.frame#4 4 -weight 0 -minsize 30
	grid columnconfigure $base.frame#4 5 -weight 0 -minsize 30

	grid rowconfigure $base.frame#1 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#1 1 -weight 0 -minsize 30
	grid columnconfigure $base.frame#1 2 -weight 0 -minsize 30
# additional interface code
# end additional interface code

}


# Allow interface to be run "stand-alone" for testing

catch {
    if [info exists embed_args] {
	# we are running in the plugin
	getTextEntry_ui .
    } else {
	# we are running in stand-alone mode
	if {$argv0 == [info script]} {
	    wm title . "Text Entry"
	    getTextEntry_ui .
	}
    }
}
