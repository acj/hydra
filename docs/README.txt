HydraVJ Usage:

HydraVJ can easily be executed directly or embedded into your
own Java code. Please examine the file PromelaTest1.java for
an example as to how to inject Hydra into your code. 

In order to execute HydraVJ you only need to type the following
command from your shell or command prompt:

> java PromelaTest1 <Source_XMI_filename> 
	<Promela_Output_filename> [<Intermediate_HIL_output>]

Here are the parameter descriptions:
	Source_XMI_filename: This is the source filename of the
XMI 1.2 export of your UML Model (currently tested ONLY with
Rational XDE).  Your path should NOT contain any spaces (or
should be escaped using double quotes or back slashes),
otherwise Java will not parse the path correctly.
	 Promela_Output_filename: This is the destination
filename of your Promela output.  If the file already exists, it
will be overwritten.  As in your source filename, this path
should not contain spaces. 
	Intermediate_HIL_output (*optional*): If this third
parameter is encountered, Hydra will write the contents of its
intermediate HIL output to the specified file.  This is useful
when debugging the model and parsing errors are encountered when
processing this normally hidden intermediate file.  As in your
source filename, this path should not contain spaces. 

-----

PromelaTest1 will also ask for an input file if no parameters are
specified. Upon successful completion, no further output will be
presented to the user beyond the standard greeting.

When running from eclipse, simply add the proper parameters
presented above.

Good Luck!

-Karli Lopez
lopezkar@msu.edu
