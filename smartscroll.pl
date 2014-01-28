# Copyright (c) 2014 Birunthan Mohanathas
#
# Licensed under the MIT license <http://opensource.org/licenses/MIT>. This
# file may not be copied, modified, or distributed except according to those
# terms.

use strict;
use warnings;

use Irssi;
use Irssi::TextUI;

our $VERSION = '1.0.0';
our %IRSSI = (
    authors     => 'Birunthan Mohanathas',
    contact     => 'firstname@lastname.com',
    name        => 'smartscroll',
    description => 'Limits autoscroll to a single page for inactive ' .
                   'windows and adds a separator line to differentiate new' .
                   'messages',
    license     => 'MIT',
    url         => 'http://poiru.net',
);

Irssi::signal_add('window changed', sub {
    my ($window, $old_window) = @_;

    if ($old_window && $old_window->view()->{'bottom'}) {
        my $line = $old_window->view()->get_bookmark('smartscroll');
        if (defined $line) {
            # Get rid of the previous separator line.
            $old_window->view()->remove_line($line);
        }

        # Add the separator line and bookmark it.
        $old_window->print('-' x 20, MSGLEVEL_NEVER);
        $old_window->view()->set_bookmark_bottom('smartscroll');

        $old_window->view()->set_scroll(0);
    }

    if ($window && $window->view()->{'scroll'} == 0) {
        my $line = $window->view()->get_bookmark('smartscroll');
        if ($line) {
            # If the separator line is not the last line any longer, we scroll
            # down. Otherwise, we get rid of it.
            if ($line->next) {
                my $count = $window->view()->{'height'} - 1 || 1;
                $window->view()->scroll($count);
            } else {
                $window->view()->remove_line($line);
            }
        }

        $window->view()->set_scroll(1);
    }
});

