@echo off
python tools/make_grd.py --path=web --output=web/wnmp.grd --pak=wnmp.pak && python tools/grit/grit.py -i web/wnmp.grd build -o wnmp