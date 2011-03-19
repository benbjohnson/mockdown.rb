mockdown -- A Markdown-inspired mockup tool
=============================================

### THIS PROJECT IS IN PLANNING RIGHT NOW. ###


## DESCRIPTION

Mockdown is a language for quickly creating mockups using a text editor.
Mockups can be exported to a variety of formats and mockdown definition files
are plain text so they work well with version control systems.

Mockdown follows the rules of [Semantic Versioning](http://semver.org/).


## INSTALL

Mockdown only works with JRuby. Visit the [JRuby web site](http://jruby.org) to
download the latest version.

If you're running RVM, run the following commands to install JRuby:

	$ rvm install jruby-1.6.0
	$ rvm use jruby-1.6.0

After you have JRuby installed, simply install the Mockdown gem:

	$ gem install mockdown


## GETTING STARTED

### Overview

Mockdown is a component-based framework for describing visual layouts. Each
component has the ability to draw itself and layout its child components. There
are some standard components to help you layout and draw your mockups.

The standard container components include:

* `col` - A container that lays out its children vertically.
* `row` - A container that lays out its children horizontally.
* `canvas` - A container that allows its children to be absolutely positioned.

The standard drawing components include:

* `line` - Draws a line between two points.
* `rect` - Draws a rectangle.
* `label` - Draws a string of text.


### Mockdown Language

The standard components can be combined into a Mockdown document using the
Mockdown language. The language is a whitespace aware language similar to
[HAML](http://haml-lang.com).

Components can be used by starting a line with a percent sign (`%`). Components
can be nested inside one another by indenting child components two spaces to the
right of the parent component. A component definition can span across multiple
lines as long as the lines are all at the same indentation level and there is no
blank space in between lines.

Mockdown also supports the inline use of the
[Markdown](http://daringfireball.net/projects/markdown) language. To use it,
simply write it indented within the component where you want to nest it.

Documents are defined by files that end with a `.mkd` extension. Here's a simple
example web site mockup created as a Mockdown document:

	%col width=960
	  # Acme Corp
	  
	  %row id=menu gap=10 padding-top=5 padding-bottom=5
	    %label text="Home"
	    %label text="About Us"
	    %label text="Contact"
	
	  Welcome to Acme Corp website. We are *really* glad you came! Please 
	  use the menu above to find what you're looking for.
	
	  %row id=footer width=100% align=center
	    Copyright 2011. Acme Corp.


## COMMAND LINE INTERFACE

Mockdown can be used from the command line to convert your Mockdown documents
into different formats. To export your Mockdown document as a PNG, simply run
the following command:

	$ mkdn -f png home_page.mkd

If the document can be successfully parsed and drawn, a file called
`home_page.png` will be created in your present working directory. If there is
a problem with generating the PNG then an error will be displayed.

Run the following to see a full list of command line options:

	$ mkdn --help


## WEB INTERFACE

The command line interface is useful to perform one time exports of documents
or to do batch processing, but viewing changes while editing can be done more
quickly using the web interface.

Use the following command to run the Mockdown web server:

	$ cd /path/to/project
	$ mkdnd run

You can also provide the project path to the server when starting:

	$ mkdnd run -- /path/to/project

Once the server is started, you can view your documents by navigating to 
`http://localhost:20202/`.

You can specify the document you want to view by appending the document name
after the last slash. For example, if your document name is `about_us.mkd` then
you can view it by navigating to `http://localhost:20202/about_us`.

You can specify the output format by appending an extension. To view your
`about_us.mkd` document as a PNG, navigate to
`http://localhost:20202/about_us.png`.


## DISCUSS

If you want to submit an awesome idea or chat about how neato it is to write
mockups in code, use the mailing list or Convore:

* Send an e-mail to [mockdown@librelist.com](mailto://mockdown@librelist.com)
  to join the mailing list.
* Join the [Convore Mockdown Group](https://convore.com/mockdown).


## CONTRIBUTE

Send a pull request with some sweet code! However, if you're sending code,
please add RSpec tests and use a named branch. Thanks!
