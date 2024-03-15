@echo off
echo TENHA CERTEZA DE QUE VOCE TEM HAXE 4.3.x INSTALADO!
echo flixel
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup
lime setup flixel
echo os otro
haxelib install hscript
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit.git
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib git faxe https://github.com/uhrobots/faxe
haxelib install polymod