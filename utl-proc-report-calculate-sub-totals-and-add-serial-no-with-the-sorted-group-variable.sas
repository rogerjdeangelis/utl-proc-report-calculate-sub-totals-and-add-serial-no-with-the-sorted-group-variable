Proc report calculate sub totals and add serial no with the sorted group variable

I created a table that you can easily create the sorted static report you desire.
I think this is more flexible.

Ypu may be able to do tis with a single proc report but you might
be painted into a corner.

github
https://tinyurl.com/y74r5ajp
https://github.com/rogerjdeangelis/utl-proc-report-calculate-sub-totals-and-add-serial-no-with-the-sorted-group-variable

SAS Forum
https://tinyurl.com/yc3afhzm
https://communities.sas.com/t5/SAS-Procedures/Need-to-calculate-sub-total-total-and-to-generate-serial-no/m-p/524224

INPUT
=====
data have;
 input Group1$ Head :$20. Reported;
cards4;
Adult Drink 2
Adult Commit 2
Adult Medicine 1
Adult Grains 5
Adult Others 1
Burglary Banks 1
Burglary CommercialPlaces 3
Burglary Residential 5
Burglary Others 6
Hurt Attack 4
Hurt Disputes 3
Hurt Others 7
;;;;
run;quit;

WORK.HAVE total obs=12

  GROUP1      HEAD                REPORTED

  Adult       Drink                   2
  Adult       Commit                  2
  Adult       Medicine                1
  Adult       Grains                  5
  Adult       Others                  1
  Burglary    Banks                   1
  Burglary    CommercialPlaces        3
  Burglary    Residential             5
  Burglary    Others                  6
  Hurt        Attack                  4
  Hurt        Disputes                3
  Hurt        Others                  7

EXAMPLE OUTPUT
--------------

Use report to give your your static output and a sorted table;

options missing=' ';
proc report data=want missing out=wantSrt(drop=_break_);
define site / order;
define head / order;

run;quit;

  SITE  HEAD                   REPORTED
     1  Adult
        Commit                        2
        Drink                         2  ** Commit is moved before Drink
        Grains                        5
        Medicine                      1
        Others                        1
        Sub Total                    11
     2  Banks                         1
        Burglary
        CommercialPlaces              3
        Others                        6
        Residential                   5
        Sub Total                    15
     3  Attack                        4
        Disputes                      3
        Hurt
        Others                        7
        Sub Total                    14
        Total                        40


PROCESS;
========

data want;
  retain site tot subtot 0;
  set have end=dne;
  by group1;
  if first.group1 then do;
     savHed=Head    ; Head=group1;
     savRpt=reported; reported=.;
     site+1;
     SubTot=0;
     output;
     reported=savRpt;
     Head=savHed;
  end;
  subtot+reported;
  tot + reported;
  output;
  if last.group1 then do;
     Head='Sub Total';
     reported=subtot;
     output;
  end;
  if dne then do;
     head='Total';
     reported=tot;
     output;
  end;
  keep site head reported;
run;quit;

options missing=' ';
proc report data=want missing out=wantSrt(drop=_break_);
define site / order;
define head / order;



OUTPUT
======
see above;



