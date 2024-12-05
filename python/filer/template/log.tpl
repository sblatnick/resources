<!--(set_escape)-->
  NONE
<!--(end)-->
#!
#!  Define Macros:
#!
<!--(macro style)-->
  <!--(if exists("width"))-->
    <!--(if width > len(text))-->
$!setvar("extra", "int(width - len(text)) * \" \"")!$#!
    <!--(else)-->
$!setvar("text", "text[0:width]")!$#!
    <!--(end)-->
  <!--(end)-->
@! "\033[%sm%s\033[0m%s" % (";".join(s for s in (str(default("bg[background]", "")), str(default("fg[color]", "")), str(default("bold", ""))) if s), text, default("extra", "")) !@
<!--(end)-->
#!
#!  Contents:
#!    (target full width: 110)
#!
#!  Details:
#!
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ @!style(width=40, text=" ")!@@!style(bold=1, text="Filer Summary Report")!@ @!style(width=41, text=" ")!@ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#!
#!  Chart:
#!
┃    <!--(for table, fill in chart.items())--> @!style(width=15, color=table, text=(str(totals[table]['count']) if fill[0] else " "))!@<!--(end)-->    ┃
<!--(for i in range(10))-->
┃    #!
  <!--(for table, fill in chart.items())-->#!
    <!--(if fill[i])-->#!
$!setvar("filler", "\"███████████████\"")!$#!
    <!--(elif fill[i+1])-->#!
$!setvar("filler", "str(totals[table]['count'])")!$#!
    <!--(else)-->#!
$!setvar("filler", "\" \"")!$#!
    <!--(end)-->#!
 @!style(width=15, color=table, text=filler)!@#!
  <!--(end)-->
    ┃
<!--(end)-->
┃    <!--(for table, count in totals.items())--> @!style(width=15, text=table.title())!@<!--(end)-->    ┃
#!┃    <!--(for table, count in totals.items())--> @!style(width=15, text=str(count))!@<!--(end)-->    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  @!style(width=104, text="Note: For accurate results, make sure to run `filer scan`.")!@
#!
#!  Results:
#!
<!--(for table, counts in totals.items())-->
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ @!style(bold=1, text=table, background=table)!@ @!style(width=101 - len(table), text=" ")!@ ┃
┣━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
  <!--(for name, count in counts.items())-->
┃@!style(bold=1, width=16, text=name)!@│@!style(width=87, text=str(count))!@┃
  <!--(end)-->
┗━━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
<!--(end)-->
