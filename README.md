# Todo or Event?

A rather simple library for guessing what a line is meant to be. Given a string
of proper English, return either ':todo' or ':event'.

A string is determined to be a todo rather an event if the line is thought to be
a command - an action item for you GTD folks. This is determined by a simple
presumption: The line starts with a verb. If the line does not start with a verb,
it is presumed to be a description of an event, a statement.

This library checks the first and second words of the line, only if the first
word is a verb. If the second word is a verb as well, then it is presumed
that the first word has multiple definitions. (For example, 'monkey' can be a
verb or a noun.) We then presume that the line is a statement.

This assumption does not hold up entirely, however. Given the following two
lines, which are both supposed to be todos:

	Catch fish with the claw shot
	Catch some fish with the claw shot

The first line will be parsed as an event, which is technically correct
according to the rules set before, but we mean it to be a todo. The second line,
however, is parsed as we expect it to be. Therefore, it is the recommended
syntax. When attempting to use this library, be more explicit than implicit.

## Requirements

 * [Princeton's WordNet](http://wordnet.princeton.edu/)

## Copyright

Copyright (c) 2009 Colin Shea. See LICENSE for details.
