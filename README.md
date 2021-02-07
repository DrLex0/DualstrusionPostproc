# Dualstrusion-Postproc
*Post-processing script for high-quality dual extrusion on 3D printers like the FlashForge Creator Pro*<br>
by Alexander Thomas, aka Dr. Lex<br>
Current version: 1.1<br>
Contact: visit <https://www.dr-lex.be/lexmail.html><br>
&nbsp;&nbsp;&nbsp;&nbsp;or use my gmail address "doctor.lex".


## What is it?
See <https://www.dr-lex.be/software/print3d-dualstrusion.html> for more information.

This is a Perl script that transforms G-code as produced by PrusaSlicer (Slic3r) into more optimal code for creating high-quality dual extrusion prints with printers similar to the FlashForge Creator Pro (running Sailfish firmware), which have two extruders on a single carriage. It avoids that the deactivated nozzle oozes across the print, and it primes the active extruder before resuming printing.

In a nutshell, this script:
1. maintains a priming/wiping tower behind the printed object,
2. ensures that the number of tool changes are minimized regardless of how inefficiently the slicer schedules them,
3. reliably lowers the temperature of the unused nozzle to keep it from oozing (don't try to rely on Slic3r's own ooze prevention, it failed last time I tried it).
4. does the tool change above the wipe tower and then primes the newly activated nozzle,
5. wipes the deactivated nozzle on the tower before resuming the print (the wipe position is shuffled to reduce risk of colliding with previous ooze).

This script is *not* plug-and-play, unless you use the workflow and configuration files as described on <https://www.dr-lex.be/software/ffcp-slic3r-profiles.html> and <https://github.com/DrLex0/FFCP-GCodeSnippets>


## Installing and using
The script will only work with relative E distances. This must be enabled in your printer profile, which should be the case if you use [my latest configurations and G-code](https://github.com/DrLex0/FFCP-GCodeSnippets).

The script looks for specific markers that occur in my own start and tool change G-code snippets, as provided in the above links. You can use the script with your own G-code of course, but you will need to either edit the `MARK` variables to detect your own comment lines in the code, or modify your G-code to include those same markers.

The actual start G-code does not matter because it will be overridden by the script. The only requirements are that it starts with the value of `$MARK_START_CODE_BEGIN`, and ends with a line that ends with “`;@body`”.

### Deploying the script

To get started, place the script from the *src* directory somewhere in a convenient location, and ensure it is executable (`chmod +x`).
Then, either:
* manually invoke it to process gcode files as follows (remember: never redirect to the same file as the input):<br>
  `./dualstrusion-postproc.pl input.gcode > output.gcode`
* or you could also invoke it like this:<br>
  `./dualstrusion-postproc.pl -o output.gcode input.gcode`<br>
  (In Windows, if you have installed a Perl interpreter, prepend `perl` to the above commands and either omit the `./` or use Windows-style paths.)
* or use a wrapper script that does the above, and configure that wrapper script in each of your Print Settings in PrusaSlicer/Slic3r (*Output options* → *Post-processing scripts*).

If you use [my PrusaSlicer configs and workflow](https://github.com/DrLex0/FFCP-GCodeSnippets) with the `make_fcp_x3g` wrapper script, first make sure you have set up the configs and that script according to their [instructions](https://www.dr-lex.be/software/ffcp-slic3r-profiles.html#config). Then, open the `make_fcp_x3g` script in an editor of your choice and configure the line containing `DUALSTRUDE_SCRIPT` according to the instructions given a bit higher up in the file.

You can configure the `make_fcp_x3g` script to keep a copy of the unprocessed code as a copy with “`_orig`” appended to the name. This allows to manually run the script again with different settings in case you want to change something without re-exporting the G-code file from Slic3r.

### When preparing a print

It is recommended to enable a tall *skirt* that reaches at least up to the last layer that contains two materials. Again, see the [main article](https://www.dr-lex.be/software/print3d-dualstrusion.html) for more information.

Currently the script will place the tower behind the print without considering the bed size or trying to shift things around, so make sure there is enough room (at least 22 mm) behind your print before exporting it. This means you won't be able to do huge dual extrusions that take up the entire bed, but the risk of those failing is pretty high anyway.

The bed temperature will be set according to the material in the *right* extruder, unless there is only material from the left extruder in the first layer, then it will be according to the left extruder material. What this means in practice, is that when you are printing with materials that have different optimal bed temperatures, ideally the right extruder should be loaded with the filament that extrudes the most material in the first layer.

So far I have only tested this with not very tall prints. I suspect that the wipe/prime tower is likely to be knocked over when printing something very tall. Anything that has 2 materials above 60mm is likely to be risky. Improving wipe tower stability is on my TODO list.

## Notes
The script is specifically written for PrusaSlicer / Slic3r. It might be possible to adapt it to other slicers (like Simplify3D) but this will require making the parsing routines more robust (they are lazily written to work with typical Slic3r-style output only) and maybe also changes to the logic. Contributions to make the script usable with other slicers are welcome!

## License
This script is released under a [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/).

Use at your own risk. The author is not responsible for damage to your printer or other accidents due to the use of this script.
