
// ����� ��� ����
Array.prototype.id = "idmagazineMenu"
maMenu = new Array(10)
maMenu[0] = new menuLink("������" , "/articles/magazine/default.asp")
maMenu[1] = new menuLink("��� 2006", "/articles/magazine/2006.asp")
maMenu[2] = new menuLink("��� 2005", "/articles/magazine/2005.asp")
maMenu[3] = new menuLink("��� 2004", "/articles/magazine/2004.asp")
maMenu[4] = new menuLink("��� 2003", "/articles/magazine/2003.asp")
maMenu[5] = new menuLink("��� 2002", "/articles/magazine/2002.asp")
maMenu[6] = new menuLink("��� 2001", "/articles/magazine/2001.asp")
maMenu[7] = new menuLink("��� 2000", "/articles/magazine/2000.asp")
maMenu[8] = new menuLink("��� 1999", "/articles/magazine/1999.asp")
maMenu[9] = new menuLink("��������", "/articles/magazine/subscribe.asp")

coMenu = new Array(10)
coMenu.id = "idcolumnsMenu"
coMenu[0] = new menuLink("�������", "/articles/editor/default.asp")
coMenu[1] = new menuLink("������� ���������", "/articles/editor/default.asp")
coMenu[2] = new menuLink("� - Stuff", "/post/12913/default.asp")
coMenu[3] = new menuLink("IRC manual", "/articles/common/IRC/default.asp")
coMenu[4] = new menuLink("�������", "/articles/common/phreak/default.asp")
coMenu[5] = new menuLink("������� ������ �� ���", "/articles/common/girls/default.asp")
coMenu[6] = new menuLink("iFAQ", "/articles/common/faq/default.asp")
coMenu[7] = new menuLink("������ ���-<br>���� \"�����\"", "/articles/common/releases/default.asp")
coMenu[8] = new menuLink("e-BOOK", "/articles/book/default.asp")
coMenu[9] = new menuLink("Tips & Tricks", "/articles/common/news.asp")

haMenu = new Array(7)
haMenu.id = "idhackMenu"
haMenu[0] = new menuLink("�����", "/articles/hack/default.asp")
haMenu[1] = new menuLink("�������", "/articles/hack/results.asp?tosearch=theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzNEWSz%2A%27+and+not+theme+like+%27%2AzSOFT%2A%27+and+not+theme+like+%27%2AzNETz%2A%27")
haMenu[2] = new menuLink("����", "/articles/hack/results.asp?tosearch=theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzINTERNETz%2A%27+and+theme+like+%27%2AzINFOz%2A%27")
haMenu[3] = new menuLink("����", "/articles/hack/results.asp?tosearch=theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzINFOz%2A%27+and+theme+like+%27%2AzSOFTz%2A%27")
haMenu[4] = new menuLink("Deface", "/articles/hack/results.asp?tosearch=theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzINTERNETz%2A%27+and+theme+like+%27%2AzNETz%2A%27")
haMenu[5] = new menuLink("������", "/articles/hack/results.asp?tosearch=theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzINFOz%2A%27+and+theme+like+%27%2AzOTHERHACKz%2A%27")
haMenu[6] = new menuLink("����", "/articles/hack/people.asp")

//amMenu = new Array(3)
//amMenu.id = "idambMenu"
//amMenu[0] = new menuLink("�������-<br>��������", "/articles/amb/default.asp")
//amMenu[1] = new menuLink("����������", "/articles/amb/results.asp?tosearch=theme+like+%27%2AzAMBz%2A%27+and+theme+like+%27%2AzCOMPz%2A%27")
//amMenu[2] = new menuLink("�����", "/articles/amb/results.asp?tosearch=theme+like+%27%2AzAMBz%2A%27+and+theme+like+%27%2AzLIFEz%2A%27")

//hdMenu = new Array(6)
//hdMenu.id = "idhardMenu"
//hdMenu[0] = new menuLink("������", "/articles/hard/default.asp")
//hdMenu[1] = new menuLink("3D", "/articles/hard/results.asp?tosearch=theme+like+%27%2AzHARDz%2A%27+and+theme+like+%27%2Az3Dz%2A%27")
//hdMenu[2] = new menuLink("���������...", "/articles/hard/results.asp?tosearch=theme+like+%27%2AzHARDz%2A%27+and+theme+like+%27%2AzKEYBOARDz%2A%27")
//hdMenu[3] = new menuLink("����", "/articles/hard/results.asp?tosearch=theme+like+%27%2AzHARDz%2A%27+and+theme+like+%27%2AzSOUNDz%2A%27")
//hdMenu[4] = new menuLink("HDD, CD...", "/articles/hard/results.asp?tosearch=theme+like+%27%2AzHARDz%2A%27+and+theme+like+%27%2AzSTORAGEz%2A%27")
//hdMenu[5] = new menuLink("������", "/articles/hard/results.asp?tosearch=theme+like+%27%2AzHARDz%2A%27+and+theme+like+%27%2AzOTHERHARDz%2A%27")

soMenu = new Array(6)
soMenu.id = "idsoftMenu"
soMenu[0] = new menuLink("����", "/articles/soft/default.asp")
soMenu[1] = new menuLink("������", "/articles/soft/results.asp?tosearch=theme+like+%27%2AzSOFTz%2A%27+and+%28theme+like+%27%2AzFIREWALLz%2A%27+or+theme+like+%27%2AzANTIVIRz%2A%27+or+theme+like+%27%2AzDETECTz%2A%27+or+theme+like+%27%2AzSHAREVAREz%2A%27+or+theme+like+%27%2AzCONTRAz%2A%27%29")
soMenu[2] = new menuLink("���������", "/articles/soft/results.asp?tosearch=theme+like+%27%2AzSOFTz%2A%27+and+%28theme+like+%27%2AzNUKEz%2A%27+or+theme+like+%27%2AzFLUDz%2A%27+or+theme+like+%27%2AzSCANz%2A%27+or+theme+like+%27%2AzCRACKz%2A%27+or+theme+like+%27%2AzTROYANz%2A%27+or+theme+like+%27%2AzSPYz%2A%27+or+theme+like+%27%2AzPROz%2A%27%29")
soMenu[3] = new menuLink("����������������", "/articles/soft/results.asp?tosearch=theme+like+%27%2AzSOFTz%2A%27+and+theme+like+%27%2AzHOWz%2A%27")
soMenu[4] = new menuLink("Bug Track", "/articles/common/result.asp?tosearch=theme+like+%27%2AzSOFTz%2A%27+and+theme+like+%27%2AzHACKz%2A%27+and+theme+like+%27%2AzNEWSz%2A%27")
soMenu[5] = new menuLink("Online Gamez", "/articles/games/default.asp")


//huMenu = new Array(7)
//huMenu.id = "idhumorMenu"
//huMenu[0] = new menuLink("����", "/articles/humor/default.asp")
//huMenu[1] = new menuLink("���� �����", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzPROGz%2A%27")
//huMenu[2] = new menuLink("��������", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzANEKDOTz%2A%27")
//huMenu[3] = new menuLink("��������", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzPICSz%2A%27")
//huMenu[4] = new menuLink("���-�����", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzANIz%2A%27")
//huMenu[5] = new menuLink("S��������", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzSTRASHz%2A%27")
//huMenu[6] = new menuLink("������ � �", "/articles/humor/results.asp?tosearch=theme+like+%27%2AzHUMORz%2A%27+and+theme+like+%27%2AzTELEGIz%2A%27")

//feMenu = new Array(3)
//feMenu.id = "idfreeMenu"
//feMenu[0] = new menuLink("������", "/articles/free/default.asp")
//feMenu[1] = new menuLink("����", "/articles/free/results.asp?tosearch=theme+like+%27%2AzFREEz%2A%27+and+theme+like+%27%2AzNETz%2A%27")
//feMenu[2] = new menuLink("�����", "/articles/free/results.asp?tosearch=theme+like+%27%2AzFREEz%2A%27+and+theme+like+%27%2AzLIFEz%2A%27")

mpMenu = new Array(3)
mpMenu.id = "idmp3Menu"
mpMenu[0] = new menuLink("MP3", "/articles/mp3/default.asp")
mpMenu[1] = new menuLink("���", "/articles/mp3/results.asp?tosearch=theme+like+%27%2AzMP3z%2A%27")
mpMenu[2] = new menuLink("�� �������", "/articles/mp3/group.asp")

xsMenu = new Array(4)
xsMenu.id = "idxshopMenu"
xsMenu[0] = new menuLink("������ � ����� &quot;�&quot;", "/articles/xshop/default.asp")
xsMenu[1] = new menuLink("������", "/articles/xshop/default.asp?item=apparel")
xsMenu[2] = new menuLink("�������", "/articles/xshop/default.asp?item=pad")
xsMenu[3] = new menuLink("����������", "/articles/xshop/default.asp?item=appurtenance")
