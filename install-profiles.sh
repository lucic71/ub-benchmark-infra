#!/bin/sh -ex

# it's a shame that there is no batch-debug-install. i want to see the
# steps for compiling the profile but i want to do it in an automated
# way. pts sometimes goes crazy and says that there are missing
# dependencies on the system even if it installs them. it then promts
# a list of further steps. i patched the source code by exiting always
# when something like this happens. the patch is the following:
#
# diff --git a/pts-core/objects/client/pts_external_dependencies.php b/pts-core/objects/client/pts_external_dependencies.php
# index 3dd5877c4..c01f2c779 100644
# --- a/pts-core/objects/client/pts_external_dependencies.php
# +++ b/pts-core/objects/client/pts_external_dependencies.php
# @@ -243,7 +244,8 @@ class pts_external_dependencies
#                                         'QUIT' => 'Quit the current Phoronix Test Suite process.'
#                                         );
#  
# -                               $selected_action = pts_user_io::prompt_text_menu('Missing dependencies action', $actions, false, true);
# +                               //$selected_action = pts_user_io::prompt_text_menu('Missing dependencies action', $actions, false, true);
# +                               $selected_action = 'QUIT';
#  
#                                 switch($selected_action)
#                                 {

# /usr/bin/cc is a symbolink link to ./cc
# /usr/bin/c++ is a symbolink link to ./c++

export CC=/usr/bin/cc
export CXX=/usr/bin/c++

/usr/bin/time sh -c 'cat rand-profiles.txt | xargs -n1 /usr/bin/time php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php debug-install | tee install-log.txt'
