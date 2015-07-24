import os


configuration = ""
for variable in os.environ:
    if "BUILDOUT_" not in variable:
        continue
    tag = variable[9:].lower().replace('_', '-')
    configuration += "%s = %s\n" % (tag, os.environ[variable].strip('"\''))

if configuration:
    header ="""\
[buildout]
extends = base.cfg

[zeoserver]
"""
    buildout = open("/opt/zeoserver/buildout.cfg", "w")
    print >> buildout, header + configuration,