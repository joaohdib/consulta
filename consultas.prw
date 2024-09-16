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

	oBrowse:AddColumn(TCColumn():New('Código do Médico',{||TM5->TM5_USUARI},,,,'LEFT',,.F.,.F.,,,,.F.,))
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
	Local aFornecedores := getFornecedores()
	Local aExaRef := {"", "1=Referencial","2=Sequencial"}
	Local aOriaAgr := {"", "1=Ocupacional","2=Não Ocupacional"}
	Local aIndAgr := {"", "1=Sim", "2=Não"}
	Local aIndRes := {"", "1=Normal", "2=Alterado"}
	Local aNatexa := {"", "1=Admissional", "2=Periódico", "3=Mudança função", "4=Retorno ao trabalho", "5=Demissional"}
	Local aOrigem := {"1","2"}
	Local aValores := { ;
		{'', 'Filial'}, ;
		{'', 'Ficha Médica'}, ;
		{'', 'Codigo do Exame'}, ;
		{Date(), 'Data do Exame'}, ;
		{'', 'Fornecedor'}, ;
		{'', 'Loja Fornec.'}, ;
		{'', 'Filial Func.'}, ;
		{'', 'Matricula do Func.'}, ;
		{'', 'Origem Exame'}, ;
		{'', 'Numero do PCMSO'},;
		{Date(), 'Data do result. do Exame'},;
		{'', 'Horário do Exame'},;
		{'', 'Código do Médico'},;
		{'', 'Código de Conclusão'},;
		{'','Indicador Res. do Exame'},;
		{'','Indicador Natureza do Exame'},;
		{'','Observação Sobre Result.'},;
		{'','Codigo do Centro de Custo'},;
		{'','Funcao do Funcionario'},;
		{'','C.B.O.'},;
		{'','Numero do ASO'},;
		{'','Codigo do Turno Trabalho'},;
		{'', 'Detalhes Resultado Exame'},;
		{'', 'Exame Referencial?'},;
		{'', 'Agravamento?'},;
		{'', 'Origem Agravamento'},;
		{'', 'Log de Inclusao'},;
		{'', 'Log de Alteracao'},;
		{'', 'Cod.DENATRAN'};
		}


	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 030, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 030, 100, {|u|if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)

	oFornecedores  := TComboBox():New( 060, 001, {|u|if(PCount()>0,aValores[5][1]:=u,aValores[5][1])}, aFornecedores, 100, , oJanela,,{||alteraLoja(@oFornecedores, @oLoja)},,,,.T.,,,,,,,,, aValores[5][1], aValores[5][2], 1, , )

	oLoja	       := TGet():New( 060, 100, {|u|if(PCount()==0, aValores[6][1], aValores[6][1]:=u)}, oJanela, 096, 009, "@N 99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[6][2],1,,,,.T.,)

	oFilFun	       := TGet():New( 090, 001, {|u|if(PCount()==0, aValores[7][1], aValores[7][1]:=u)}, oJanela, 096, 009, "@E XX", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[7][2],1,,,,.T.,)

	oMat           := TGet():New( 090, 100, {|u|if(PCount()==0, aValores[8][1], aValores[8][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[8][2],1,,,,.T.,)

	oOrigem        := TComboBox():New( 120, 001, {|u|if(PCount()>0,aValores[9][1]:=u,aValores[9][1])}, aOrigem, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[9][1], aValores[9][2], 1, , )

	oPcmso         := TGet():New( 120, 100, {|u|if(PCount()==0, aValores[10][1], aValores[10][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[10][2],1,,,,.T.,)

	oDataResult    := TGet():New( 150, 100, {|u|if(PCount()==0, aValores[11][1], aValores[11][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[11][2],1,,,,.T.,)

	oHora          := TGet():New( 150, 001, {|u| if(PCount()==0, aValores[12][1], aValores[12][1]:=u)}, oJanela, 096, 009, "@N 99:99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[12][2],1,,,,.T.,)

	oCodMed        := TGet():New( 180, 001, {|u|if(PCount()==0, aValores[13][1], aValores[13][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[13][2],1,,,,.T.,)

	oCodRes        := TGet():New( 180, 100, {|u|if(PCount()==0, aValores[14][1], aValores[14][1]:=u)}, oJanela, 096, 009, "@E XXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[14][2],1,,,,.T.,)

	oIndRes		   := TComboBox():New( 210, 001, {|u|if(PCount()>0,aValores[15][1]:=u,aValores[15][1])}, aIndRes, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[15][1], aValores[15][2], 1, , )

	oNatexa        := TComboBox():New( 210, 100, {|u|if(PCount()>0,aValores[16][1]:=u,aValores[16][1])}, aNatexa, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[16][1], aValores[16][2], 1, , )

	oObserv        := TGet():New( 240, 001, {|u|if(PCount()==0, aValores[17][1], aValores[17][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[17][2],1,,,,.T.,)

	oCc            := TGet():New( 240, 100, {|u|if(PCount()==0, aValores[18][1], aValores[18][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[18][2],1,,,,.T.,)

	oCodFun        := TGet():New( 270, 001, {|u|if(PCount()==0, aValores[19][1], aValores[19][1]:=u)}, oJanela, 096, 009, "@E XXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[19][2],1,,,,.T.,)

	oCbo           := TGet():New( 270, 100, {|u|if(PCount()==0, aValores[20][1], aValores[20][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[20][2],1,,,,.T.,)

	oNumAso        := TGet():New( 300, 001, {|u|if(PCount()==0, aValores[21][1], aValores[21][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[21][2],1,,,,.T.,)

	oCodTurno      := TGet():New( 300, 100, {|u|if(PCount()==0, aValores[22][1], aValores[22][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[22][2],1,,,,.T.,)

	oDetResum      := TGet():New( 000, 200, {|u|if(PCount()==0, aValores[23][1], aValores[23][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[23][2],1,,,,.T.,)

	oExaRef        := TComboBox():New( 030, 200, {|u|if(PCount()>0,aValores[24][1]:=u,aValores[24][1])}, aExaRef, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[24][1], aValores[24][2], 1, , )

	oIndaGr		   := TComboBox():New( 060, 200, {|u|if(PCount()>0,aValores[25][1]:=u,aValores[25][1])}, aIndAgr, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[25][1], aValores[25][2], 1, , )

	oOriaAgr       := TComboBox():New( 090, 200, {|u|if(PCount()>0,aValores[26][1]:=u,aValores[26][1])}, aOriaAgr, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[26][1], aValores[26][2], 1, , )

	oUserGi        := TGet():New( 120, 200, {|u|if(PCount()==0, aValores[27][1], aValores[27][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[27][2],1,,,,.T.,)

	oUserGa        := TGet():New( 150, 200, {|u|if(PCount()==0, aValores[28][1], aValores[28][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[28][2],1,,,,.T.,)

	oCodDena       := TGet():New( 180, 200, {|u|if(PCount()==0, aValores[29][1], aValores[29][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[29][2],1,,,,.T.,)

	/////////////////////// BOTÃO 'Inserir' ///////////////////////

	oButton3      := TButton():Create(oJanela, 340 ,1,"Inserir",{||insertDb(aValores, oJanela)},75,20,,,,.T.,,,,,,)

	oJanela:Activate(,,,.T.,,,)


RETURN


Static Function insertDb(aValores, oJanela)

	Local verificaHora := verificarHorario(aValores[12][1], aValores[13][1], aValores[4][1])
	Local aValoresFaltantes := verificaValores(aValores)
	Local cValoresTexto := ''
	Local nI

	If Len(aValoresFaltantes) > 0
		For nI := 1 To Len(aValoresFaltantes)
			cValoresTexto += aValoresFaltantes[nI]
			cValoresTexto += ' '
			cValoresTexto += Chr(13)+Chr(10)
		Next
		FWAlertError("Os seguintes valores não podem estar vazios:" + Chr(13)+Chr(10) + cValoresTexto ,"Erro na inserção")
		RETURN
	Endif

	If verificaHora == 0
		FWAlertError("Medico ja tem consulta neste horario","Erro na inserção")
		RETURN
	Endif

	dbSelectArea("TM5")
	DBGOTOP()

	RecLock("TM5", .T.)
	TM5_FILIAL := aValores[1][1]
	TM5_NUMFIC := aValores[2][1]
	TM5_EXAME  := aValores[3][1]
	TM5_DTPROG := aValores[4][1]
	TM5_FORNEC := aValores[5][1]
	TM5_LOJA   := aValores[6][1]
	TM5_FILFUN := aValores[7][1]
	TM5_MAT    := aValores[8][1]
	TM5_ORIGEX := aValores[9][1]
	TM5_PCMSO  := aValores[10][1]
	TM5_DTRESU := aValores[11][1]
	TM5_HRPROG := aValores[12][1]
	TM5_USUARI := aValores[13][1]
	TM5_CODRES := aValores[14][1]
	TM5_INDRES := Left(aValores[15][1],1)

	TM5_NATEXA := Left(aValores[16][1],1)
	TM5_OBSERV := aValores[17][1]
	TM5_CC     := aValores[18][1]
	TM5_CODFUN := aValores[19][1]
	TM5_CBO    := aValores[20][1]
	TM5_NUMASO := aValores[21][1]
	TM5_TNOTRA := aValores[22][1]
	TM5_DESRES := aValores[23][1]
	TM5_EXAREF := Left(aValores[24][1],1)
	TM5_INDAGR := Left(aValores[25][1],1)
	TM5_ORIAGR := Left(aValores[26][1],1)
	TM5_USERGI := aValores[27][1]
	TM5_USERGA := aValores[28][1]
	TM5_CODDET := aValores[29][1]

	MsUnlock()

	TM5->(dbCloseArea())

	FWAlertSuccess("Consulta inserida com sucesso", "Inserida")
	oJanela:end()

RETURN

Static Function update()
	Local oJanela  := TDialog():New(0, 0, 730, 550, 'Cadastro de consultas', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	Local aFornecedores := getFornecedores()
	Local aOrigem := {"1","2"}
	Local aValores := { ;
		{TM5->TM5_FILIAL, 'Filial'}, ;
		{TM5->TM5_NUMFIC, 'Ficha Médica'}, ;
		{TM5->TM5_EXAME, 'Codigo do Exame'}, ;
		{TM5->TM5_DTPROG, 'Data do Exame'}, ;
		{TM5->TM5_FORNEC, 'Fornecedor'}, ;
		{TM5->TM5_LOJA, 'Loja Fornec.'}, ;
		{TM5->TM5_FILFUN, 'Filial Func.'}, ;
		{TM5->TM5_MAT, 'Matricula do Func.'}, ;
		{TM5->TM5_ORIGEX, 'Origem Exame'}, ;
		{TM5->TM5_PCMSO, 'Numero do PCMSO'}, ;
		{TM5->TM5_DTRESU, 'Data do result. do Exame'},;
		{TM5->TM5_HRPROG, 'Horário do Exame'},;
		{TM5->TM5_USUARI, 'Código do Médico'} ;
		}


	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 020, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 020, 100, {|u| if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)

	oFornecedores  := TComboBox():New( 040, 001, {|u|if(PCount()>0,aValores[5][1]:=u,aValores[5][1])}, aFornecedores, 100, , oJanela,,{||alteraLoja(@oFornecedores, @oLoja)},,,,.T.,,,,,,,,, aValores[5][1], aValores[5][2], 1, , )
	selecionaFornecedor(@oFornecedores, TM5->TM5_FORNEC)

	oLoja	       := TGet():New( 040, 100, {|u|if(PCount()==0, aValores[6][1], aValores[6][1]:=u)}, oJanela, 096, 009, "@N 99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[6][2],1,,,,.T.,)

	oFilFun	       := TGet():New( 060, 001, {|u|if(PCount()==0, aValores[7][1], aValores[7][1]:=u)}, oJanela, 096, 009, "@E XX", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[7][2],1,,,,.T.,)

	oMat           := TGet():New( 060, 100, {|u|if(PCount()==0, aValores[8][1], aValores[8][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[8][2],1,,,,.T.,)

	oOrigem        := TComboBox():New( 080, 001, {|u|if(PCount()>0,aValores[9][1]:=u,aValores[9][1])}, aOrigem, 100, , oJanela,,,,,,.T.,,,,,,,,, aValores[9][1], aValores[9][2], 1, , )

	oPcmso         := TGet():New( 080, 100, {|u|if(PCount()==0, aValores[10][1], aValores[10][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[10][2],1,,,,.T.,)

	oDataResult    := TGet():New( 120, 100, {|u|if(PCount()==0, aValores[11][1], aValores[11][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[11][2],1,,,,.T.,)

	oHora          := TGet():New( 120, 001, {|u| if(PCount()==0, aValores[12][1], aValores[12][1]:=u)}, oJanela, 096, 009, "@N 99:99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,.F.,, aValores[12][2],1,,,,.T.,)

	oCodMed        := TGet():New( 150, 001, {|u|if(PCount()==0, aValores[13][1], aValores[13][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,,,,,,,,.T.,,, aValores[13][2],1,,,,.T.,)

	oButton3   := TButton():Create(oJanela,340,1,"Atualizar",{||updateDb(TM5->(RecNo()),aValores, oJanela)},75,20,,,,.T.,,,,,,)

	oJanela:Activate(,,,.T.,,,)



RETURN


Static Function updateDb(recno, aValores, oJanela)

	Local verificaHora := verificarHorario(aValores[12][1], aValores[13][1], aValores[4][1])
	Local aValoresFaltantes := verificaValores(aValores)
	Local cValoresTexto := ''
	Local nI

	If Len(aValoresFaltantes) > 0
		For nI := 1 To Len(aValoresFaltantes)
			cValoresTexto += aValoresFaltantes[nI]
			cValoresTexto += ' '
			cValoresTexto += Chr(13)+Chr(10)
		Next
		FWAlertError("Os valores não podem estar vazios:" + Chr(13)+Chr(10) + cValoresTexto ,"Erro na inserção")
		RETURN
	Endif

	If verificaHora == 0
		FWAlertError("Medico ja tem consulta neste horario","Erro na atualização")
		RETURN
	Endif

	cQryUpd := "UPDATE " + RetSqlName("TM5") + " "
	cQryUpd += "SET tm5_filial = '" + aValores[1][1] + "', "
	cQryUpd += "tm5_numfic = '" + aValores[2][1] + "', "
	cQryUpd += "tm5_exame = '" + AllTrim(aValores[3][1]) + "', "
	cQryUpd += "tm5_dtprog = '" + DtoS(aValores[4][1]) + "', "
	cQryUpd += "TM5_FORNEC = '" + aValores[5][1] + "', "
	cQryUpd += "TM5_LOJA = '" + aValores[6][1] + "', "
	cQryUpd += "TM5_FILFUN = '" + aValores[7][1] + "', "
	cQryUpd += "TM5_MAT = '" + aValores[8][1] + "', "
	cQryUpd += "TM5_ORIGEX = '" + aValores[9][1] + "', "
	cQryUpd += "TM5_PCMSO = '" + aValores[10][1] + "', "
	cQryUpd += "TM5_DTRESU = '" + DtoS(aValores[11][1]) + "', "
	cQryUpd += "TM5_HRPROG = '" + aValores[12][1] + "', "
	cQryUpd += "TM5_USUARI = '" + aValores[13][1] + "' "
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
	Local oJanela  := TDialog():New(0, 0, 730, 550, 'Cadastro de consultas', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	Local aValores := { ;
		{TM5->TM5_FILIAL, 'Filial'}, ;
		{TM5->TM5_NUMFIC, 'Ficha Médica'}, ;
		{TM5->TM5_EXAME, 'Codigo do Exame'}, ;
		{TM5->TM5_DTPROG, 'Data do Exame'}, ;
		{TM5->TM5_FORNEC, 'Fornecedor'}, ;
		{TM5->TM5_LOJA, 'Loja Fornec.'}, ;
		{TM5->TM5_FILFUN, 'Filial Func.'}, ;
		{TM5->TM5_MAT, 'Matricula do Func.'}, ;
		{TM5->TM5_ORIGEX, 'Origem Exame'}, ;
		{TM5->TM5_PCMSO, 'Numero do PCMSO'}, ;
		{TM5->TM5_DTRESU, 'Data do result. do Exame'},;
		{TM5->TM5_HRPROG, 'Horário do Exame'},;
		{TM5->TM5_USUARI, 'Código do Médico'} ;
		}

	oFilial        := TGet():New( 000, 001, {|u|if(PCount()==0,aValores[1][1],aValores[1][1]:=u)}, oJanela, 096, 009,"@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[1][1],,,,,,,aValores[1][2],1,,,,.T.,)

	oFichaM		   := TGet():New( 000, 100, {|u|if(PCount()==0,aValores[2][1],aValores[2][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[2][1],,,,,,,aValores[2][2],1,,,,.T.,)

	oCodEx         := TGet():New( 030, 001, {|u|if(PCount()==0,aValores[3][1],aValores[3][1]:=u)}, oJanela, 096, 009, "@N 999999999",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[3][1],,,,,,,aValores[3][2],1,,,,.T.,)

	oData	       := TGet():New( 030, 100, {|u| if(PCount()==0, aValores[4][1], aValores[4][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,.F.,, aValores[4][2],1,,,,.T.,)

	oFornecedores  := TGet():New( 060, 001, {|u|if(PCount()==0,aValores[5][1],aValores[5][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,, aValores[5][1],,,,,,,aValores[5][2],1,,,,.T.,)

	oLoja	       := TGet():New( 060, 100, {|u|if(PCount()==0, aValores[6][1], aValores[6][1]:=u)}, oJanela, 096, 009, "@N 99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[6][2],1,,,,.T.,)

	oFilFun	       := TGet():New( 090, 001, {|u|if(PCount()==0, aValores[7][1], aValores[7][1]:=u)}, oJanela, 096, 009, "@E XX", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[7][2],1,,,,.T.,)

	oMat           := TGet():New( 090, 100, {|u|if(PCount()==0, aValores[8][1], aValores[8][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[8][2],1,,,,.T.,)

	oOrigem        := TGet():New( 120, 001, {|u|if(PCount()==0, aValores[9][1], aValores[9][1]:=u)}, oJanela, 096, 009, "@E XXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[9][2],1,,,,.T.,)

	oPcmso         := TGet():New( 120, 100, {|u|if(PCount()==0, aValores[10][1], aValores[10][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXXXXXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[10][2],1,,,,.T.,)

	oDataResult    := TGet():New( 150, 100, {|u| if(PCount()==0, aValores[11][1], aValores[11][1]:=u)}, oJanela, 096, 009, "@D", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,.F.,, aValores[11][2],1,,,,.T.,)

	oHora          := TGet():New( 150, 001, {|u| if(PCount()==0, aValores[12][1], aValores[12][1]:=u)}, oJanela, 096, 009, "@N 99:99", ,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,.F.,, aValores[12][2],1,,,,.T.,)

	oCodMed        := TGet():New( 180, 001, {|u|if(PCount()==0, aValores[13][1], aValores[13][1]:=u)}, oJanela, 096, 009, "@E XXXXXXXXXXXX",,0,,,,, .T. /*[ lPixel ]*/,,,,,,,.T.,,,,,,,.T.,,, aValores[13][2],1,,,,.T.,)


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

Static Function getFornecedores()
	Local aCodigos := {}
	Local cQuery
	Local nI

	cQuery := "SELECT A2_COD FROM "+ RetSqlName("SA2") + " WHERE D_E_L_E_T_ LIKE ' '"
	TCSqlToArr( cQuery, aCodigos, , ,)

	For nI := 1 To len(aCodigos)
		aCodigos[nI] := aCodigos[nI][1]
	Next

RETURN aCodigos

Static Function selecionaFornecedor(oFornecedores, cCod)

	Local nI
	Local aFornecedores

	aFornecedores := oFornecedores:aItems

	For nI := 1 To Len(aFornecedores)

		If aFornecedores[nI] == cCod
			oFornecedores:Select(nI)
			RETURN
		Endif
	Next

RETURN

Static Function alteraLoja(oFornecedor, oLoja)

	Local cQuery
	Local nI
	Local aLojas := {}
	Local cCod
	cCod := oFornecedor:aItems[oFornecedor:nAt]
	oLoja:cText := cCod

	cQuery := "SELECT A2_LOJA FROM "+ RetSqlName("SA2") + " WHERE A2_COD LIKE '"+ cCod + "'"
	TCSqlToArr( cQuery, aLojas, , ,)

	For nI := 1 To len(aLojas)
		aLojas[nI] := aLojas[nI][1]
	Next

	oLoja:cText := aLojas[1]

RETURN

Static Function verificarHorario(cHorario, cMedico, cData)
	Local cQuery
	Local aConsultas := {}

	cQuery := "SELECT * FROM "+ RetSqlName("TM5") + " WHERE TM5_HRPROG LIKE '"+ cHorario + "' AND TM5_USUARI LIKE '" + cMedico + "' AND TM5_DTPROG LIKE '" + DtoS(cData) + "'"
	TCSqlToArr( cQuery, aConsultas, , ,)

	If Len(aConsultas) > 0
		RETURN 0
	Else
		RETURN 1
	Endif
RETURN 1

Static Function verificaValores(aValores)
	Local aNomeValores := {}
	Local nI

	For nI := 1 to 3
		valor := aValores[nI][1]
		nome := aValores[nI][2]

		If valor == ''
			AADD(aNomeValores,nome)
		Endif
	Next


RETURN aNomeValores
