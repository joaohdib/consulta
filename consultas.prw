#include "Rwmake.ch"
#include "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "totvs.ch"

/*
//------------------------
Autor: João Henrique Dib
Projeto: Tarefa de criação de rotina para trabalhar com agendamento de consultas
10/09/2024
//------------------------
*/

User Function consultas()

	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local oButton5
	Local oMsDialog
	Local oFont := TFont():New('Arial',,24,.T.)
	Local _aSize := MsAdvSize()
	Private num := 0
	Private oFont2 := TFont():New('Arial',,13,.T.)
	Private aCord := {0,0,0,0}
	Private oBrowse

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"

	aCord[1] := 5
	aCord[2] := 5
	aCord[3] := 320
	aCord[4] := 575

	_aSize[5] := 1522
	_aSize[6] := 684
	oFont:Bold := .T.

	oMsDialog := TDialog():New(0, 0, _aSize [6]-30, _aSize [5]-200,'Cadastro de consultas',,,,,CLR_BLACK,CLR_WHITE,,,.T.)


	/////////////////////// CRIANDO VISÃO DO BANCO ///////////////////////
	dbSelectArea("TM5")

	oBrowse := MsSelBr():New( 5,5,570,315,,,,oMsDialog,,,,,,,,,,,,.F.,'TM5',.T.,,.F.,,, )

	oBrowse:AddColumn(TCColumn():New('Nome Paciente',{||/* verificaPaciente() */},,,,'LEFT',,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New('Data'  ,{||TM5->TM5_DTPROG},,,,'LEFT',,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New('Numero Ficha'  ,{||TM5->TM5_NUMFIC},,,,'LEFT',,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New('Codigo Exame'  ,{||TM5->TM5_EXAME},,,,'LEFT',,.F.,.F.,,,,.F.,))

	oBrowse:lHasMark := .T.


	/////////////////////// BOTÕES ///////////////////////
	oButton1 := TButton():Create(oMsDialog,15,581,"Inserir",{||insert()},75,20,,,,.T.,,,,,,)

	oButton2 := TButton():Create(oMsDialog,45,581,"Editar",{||update()},75,20,,,,.T.,,,,,,)

	oButton3 := TButton():Create(oMsDialog,75,581,"Deletar",{||delete()},75,20,,,,.T.,,,,,,)

	oButton4 := TButton():Create(oMsDialog,105,581,"Visualizar",{||view()},75,20,,,,.T.,,,,,,)

	oButton5 := TButton():Create(oMsDialog,135,581,"Gerar relatório",{||PRINTGRAPH()},75,20,,,,.T.,,,,,,)

	oButton6 := TButton():Create(oMsDialog,165,581,"Fechar",{||oMsDialog:end()},75,20,,,,.T.,,,,,,)

	/////////////////////// ATIVANDO JANELA ///////////////////////
	oMsDialog:Activate(,,,.T.,,,)




	RESET ENVIRONMENT
RETURN

Static Function insert()
	Local oJanela  := TDialog():New(0, 0, 730, 1100, 'Cadastro de consultas', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	Local aValores := { ;
		{'', 'Filial'}, ;
		{'', 'Ficha Médica'}, ;
		{'', 'Codigo do Exame'}, ;
		{Date(), 'Data do Exame'}, ;
		{'', 'Municipio'}, ;
		{'', 'Endereço'}, ;
		{'', 'Nome Fantasia'}, ;
		{'', 'Tipo'} ;
		}


	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 020, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 020, 100, {|u| if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)

	//oNFantasia    := TGet():New( 040, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oTFolder:aDialogs[1], 096, 009, "@E XXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	//oTelefone     := TGet():New( 040, 100, {|u|if(PCount()==0,aValoresN[3][1],aValoresN[3][1]:=u)}, oTFolder:aDialogs[1], 096, 009, "@R 9999-9999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValoresN[3][1],,,,,,,aValoresN[3][2],1,,,,.T.,)

	//OPFisica 	  := TGet():New( 060, 100, {|u|if(PCount()==0,aValoresN[4][1],aValoresN[4][1]:=u)}, oTFolder:aDialogs[1], 096, 009, "@E XXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValoresN[4][1],,,,,,,aValoresN[4][2],1,,,,.T.,)


	/////////////////////// BOTÃO 'Inserir' ///////////////////////

	oButton3      := TButton():Create(oJanela, 340 ,1,"Inserir",{||insertDb(aValores, oJanela)},75,20,,,,.T.,,,,,,)

	oJanela:Activate(,,,.T.,,,)


RETURN


Static Function insertDb(aValores, oJanela)
	dbSelectArea("TM5")
	DBGOTOP()

	RecLock("TM5", .T.)
	TM5_FILIAL := aValores[1][1]
	TM5_NUMFIC := aValores[2][1]
	TM5_EXAME := aValores[3][1]
	TM5_DTPROG := aValores[4][1]

	MsUnlock()

	TM5->(dbCloseArea())

	FWAlertSuccess("Consulta inserida com sucesso", "Inserido")
	oJanela:end()

RETURN

Static Function update()
	Local oJanela  := TDialog():New(0, 0, 730, 1100, 'Cadastro de consultas', , , , , CLR_BLACK, CLR_WHITE, , , .T.)

	Local aValores := { ;
		{TM5->TM5_FILIAL, 'Filial'}, ;
		{TM5->TM5_NUMFIC, 'Ficha Médica'}, ;
		{TM5->TM5_EXAME, 'Codigo do Exame'}, ;
		{TM5->TM5_DTPROG, 'Data do Exame'}, ;
		{'', 'Municipio'}, ;
		{'', 'Endereço'}, ;
		{'', 'Nome Fantasia'}, ;
		{'', 'Tipo'} ;
		}


	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 020, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 020, 100, {|u| if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)
	


	oButton3   := TButton():Create(oJanela,340,1,"Atualizar",{||updateDb(TM5->(RecNo()),aValores, oJanela)},75,20,,,,.T.,,,,,,)

	oJanela:Activate(,,,.T.,,,)



RETURN


Static Function updateDb(recno, aValores, oJanela)

	cQryUpd := "UPDATE " + RetSqlName("TM5") + " "
	cQryUpd += "SET tm5_filial = '" + aValores[1][1] + "', "
	cQryUpd += "tm5_numfic = '" + aValores[2][1] + "', "
	cQryUpd += "tm5_exame = '" + AllTrim(aValores[3][1]) + "', "
	cQryUpd += "tm5_dtprog = '" + DtoS(aValores[4][1]) + "' "
	cQryUpd += "WHERE R_E_C_N_O_ = '" + cValToChar(recno) + "' "
	cQryUpd += "AND D_E_L_E_T_ = ' '"

	nErro := TcSqlExec(cQryUpd)

	If nErro != 0
		msgStop("Erro.")
	Endif


	FWAlertSuccess("Atualizado com sucesso", "Atualizado")
	oJanela:end()
RETURN

Static Function delete()
	Local oJanela  := TDialog():New(0, 0, 100, 300,'Delete de consultas',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	Local oButton1
	Local oButton2

	oButton2 	  := TButton():Create(oJanela,30,10,"Apagar",{||deleteDb(TM5->(RecNo()), oJanela)},55,20,,,,.T.,,,,,,)
	oButton1      := TButton():Create(oJanela,30,90,"Cancelar",{||oJanela:end()},55,20,,,,.T.,,,,,,)


	oJanela:Activate(,,,.T.,,,)


RETURN


Static Function deleteDb(recno, oJanela)

	Local cQryUpd
	cQryUpd := "UPDATE " + RetSqlName("TM5") + " "
	cQryUpd += "SET D_E_L_E_T_ = '" + "*" + "', "
	cQryUpd += "R_E_C_D_E_L_ = '" + cValToChar(recno) + "' "
	cQryUpd += "WHERE R_E_C_N_O_ = '" + cValToChar(recno) + "' "
	cQryUpd += "AND D_E_L_E_T_ = ' '"

	nErro := TcSqlExec(cQryUpd)

	If nErro != 0

		msgStop("Erro.")

	Endif

	oJanela:end()
	oBrowse:refresh()

RETURN

Static Function view()
	Local oJanela  := TDialog():New(0, 0, 730, 1100, 'Cadastro de consultas', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	Local aValores := { ;
		{TM5->TM5_FILIAL, 'Filial'}, ;
		{TM5->TM5_NUMFIC, 'Ficha Médica'}, ;
		{TM5->TM5_EXAME, 'Codigo do Exame'}, ;
		{TM5->TM5_DTPROG, 'Data do Exame'}, ;
		{'', 'Municipio'}, ;
		{'', 'Endereço'}, ;
		{'', 'Nome Fantasia'}, ;
		{'', 'Tipo'} ;
		}

	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 020, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 020, 100, {|u| if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)


	
	oButton3      := TButton():Create(oJanela, 340,1,"Fechar",{||oJanela:end()},75,20,,,,.T.,,,,,,)
	// ATIVANDO JANELA
	oJanela:Activate(,,,.T.,,,)

RETURN

Static Function PRINTGRAPH()

	Local oReport as Object
	Local oSection as Object

	//Classe TREPORT
	oReport := TReport():New('Relatório',"Consultas",/*cPerg*/,{|oReport|ReportPrint(oReport,oSection)})

	//Seção 1
	oSection := TRSection():New(oReport,'Consultas')

	//Definição das colunas de impressão da seção 1
	TRCell():New(oSection, "TM5_FILIAL" , "TM5", "Filial", /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection, "TM5_NUMFIC", "TM5", "Num Ficha Medica" , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection, "TM5_EXAME" , "TM5", "Codigo do Exame Medico"    , , /*Tamanho*/,  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection, "TM5_DTPROG" , "TM5", "Data do Exame"    , , /*Tamanho*/,  , /*{|| code-block de impressao }*/)
	
	oReport:PrintDialog()

Return

Static Function ReportPrint(oReport, oSection)

	#IFDEF TOP

		Local cAlias := "TM5"

		BEGIN REPORT QUERY oSection

			BeginSql alias cAlias
            SELECT TM5_FILIAL,TM5_NUMFIC,TM5_EXAME,TM5_DTPROG
            FROM %table:TM5% 
			WHERE %notdel%
			EndSql

		END REPORT QUERY oSection

		//oSection:aCollection[1]:SetGraphic(4,"UF")
		oSection:PrintGraphic()
		oSection:Print()

	#ENDIF

return
