Redmine parent issue done ratio plugin
===========================

This plugin allows you to calculate the done ratio of the parent issue from its children,
even if you explicitly set the done ratio.


* Tested on Redmine 3.1.1.


Installation
------------

Clone this repository into your Redmine plugins directory, and run the migration:

    cd {RAILS_ROOT}/plugins
    git clone https://github.com/murank/redmine_parent_issue_done_ratio.git


Usage
------------

Set one of the following values in config page:

 * **Default behaivor:**
   use the issue field or status (depending on the redmine setting).
 * **Always calculate with the children:**
   always calculate the done ratio even if the default done ratio of the parent issue's status is specified.
 * **Always calculate with the children (up to the default done ratio):**
   same as above, but calclated done ratio is scaled up to the default done ratio of the status
   (the done ratio of the status is 20% and the calculated done ratio is 50%, the final done ratio becomes 10% (= 20% * 50%)).


License
-------

This plugin is released under the [MIT License](http://opensource.org/licenses/mit-license.php).

