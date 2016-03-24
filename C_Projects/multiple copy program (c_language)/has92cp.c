#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>

int main (int argc, char* argv[])
{

	char buffer[1024]; // allocate buffer
	char desfile1[] = "smallfile.txt"; // char array
	char desfile2[] = "largefile.txt"; // char array
	char* fname ; // input char pointer
	fname = argv[1]; // assign input val to char pointer
	int numcp, i, nread; // declare integers
	numcp = atoi (argv[2]); // convert character to integer
	int Filein, Fileout; // declare file oupt value
	
	if (argc != 3 || numcp < 1) 
	// check if input 3 arguments and input number of file copy not less than 1
	{
		printf ("\n%s\n", "You typed wrong number of argument\nor\nwrong number of files need be coppied!\n");
	}

	if (((strcmp(desfile1, fname)) != 0) && ((strcmp(desfile2, fname)) != 0))
	// check if the input file match either files that on record
	{
		printf ("\n%s\n\n", "Couldn't found file!");
	}	
	
	Filein = open(fname, O_RDONLY);	// open source file and ready to read
	while ((nread = (read(Filein, buffer, sizeof(buffer)))) > 0)
	// read the source file in a block of data
	{
		if (strcmp(desfile1, fname) == 0)
		// check if this is the input file "smallfile.txt"
		{
			for (i=1; i<=numcp; ++i)
			// loop and copy many files as user asked
			{
				char newfname1[sizeof"smallfile.txt"]; // find out the string length
				sprintf (newfname1, "smallfile%d.txt", i); // assign changed sring name to char variable
				Fileout = open (newfname1, O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR); // open the new file and ready to write
				write (Fileout, buffer, nread); // copy the source file contents into new file
				close(Fileout); // close the new file
			}
		}
		else
		{
		// check if this is the input file "largefile.txt"
			for (i=1; i<=numcp; ++i)
			{
			// loop and copy many files as user asked
				char newfname2[sizeof"largefile.txt"]; // find out the string length
				sprintf (newfname2, "largefile%d.txt", i); // assign changed string name to char variable
				Fileout = open (newfname2, O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR); // open the new file and ready to write
				write (Fileout, buffer, nread); // copy the source file contents into new file
				close(Fileout); // close the new file
			}
		}
	}	

	close(Filein); // close source file
	
	return 0; // terminate program
}
	

