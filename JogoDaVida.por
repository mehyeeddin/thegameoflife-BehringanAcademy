programa
{
	inclua biblioteca Mouse --> mouse
	inclua biblioteca Tipos --> tipos
	inclua biblioteca Util --> u
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> t
	
	// Cria duas MATRIZES, sendo uma auxiliar e a outra principal(tambem executando como auxiliar quando mod 2 de Evolucao = 0)
     
	inteiro Canvas[100][100], CanvasAuxiliar[100][100], Evolucao = 0, tamanho = 100
	inteiro Verde = g.criar_cor(25, 255, 156)
	inteiro Azul = g.criar_cor(25, 156, 255)
	inteiro Vermelho = g.criar_cor(255, 25, 25)
	inteiro Cinza = g.criar_cor(36,36,36)
	// Inicializa com valores aleatrios
	
	funcao vazio inicializarMatriz(inteiro &matriz[][], inteiro modo) {
		//Modos, se for 1 ele sorteia aleatoriamente um valor, e se for 0 cria um canvas vazio
		se(modo == 1) para(inteiro i = 0; i < tamanho; i++) para(inteiro j = 0; j < tamanho; j++) matriz[i][j] = u.sorteia(0, 3)
		se(modo == 0) para(inteiro i = 0; i < tamanho; i++) para(inteiro j = 0; j < tamanho; j++) matriz[i][j] = 0
		
	}

	// Define a matriz auxiliar como a evolucao da matriz x a
	
	funcao vazio evoluir(inteiro &matriz[][], inteiro &matrizAuxiliar[][]) {
		para(inteiro i = 0; i < tamanho; i++)
		para(inteiro j = 0; j < tamanho; j++) {
			// Lemos em um quadrado a soma dos uns
			inteiro soma = 0, estado = 0, celulaEstado = matriz[i][j]

			inteiro Quadrado = 1
			se(celulaEstado == 2) Quadrado = 2
			se(celulaEstado == 3) Quadrado = 3
			
			para(inteiro Linha = i-Quadrado; Linha < i+2; Linha++) {
				para(inteiro Coluna = j-Quadrado; Coluna < j+2; Coluna++) {

					// Define as Variaveis
					
					inteiro LinhaFixed = (Linha + tamanho) % tamanho
					inteiro ColunaFixed = (Coluna + tamanho) % tamanho

					
 
					
					se(nao((Linha < 0) ou (Linha > tamanho - 1) ou (Coluna < 0 ) ou (Coluna > tamanho - 1))) {
						LinhaFixed = Linha
						ColunaFixed = Coluna
					}
					
						// Soma da Posicao
						 soma += matriz[LinhaFixed][ColunaFixed]
					
			     }
			}
			soma -= matriz[i][j]
			
			//Regras do jogo da Vida
			
			se(celulaEstado == 0 e soma == 3) estado = 1 senao
			se(celulaEstado == 0 e soma == 8) estado = 2 senao
			se(celulaEstado == 2 e soma < 8) estado = 2 senao
			se(celulaEstado == 2 e soma > 8 e soma < 14) estado = 3 senao
			se(celulaEstado == 3 e soma > 8 e soma < 18) estado = 3 senao
			se(celulaEstado == 1 e ((soma >= 2 e soma <= 3) ou soma > 6)) estado = 1
			 

			//Define a celula na matrizAuxiliar
			matrizAuxiliar[i][j] = estado
		}
	}

	// funcao que desenha na tela a matriz


	
	funcao vazio desenharMatriz(inteiro &matriz[][]) {
		inteiro x = 100, y = 100
		
		para(inteiro i = 0; i < tamanho; i++) {
		para(inteiro j = 0; j < tamanho; j++) {
			// Define a cor, verde ou cinza
			se(matriz[i][j] == 1) g.definir_cor(Verde) senao 
			se(matriz[i][j] == 2) g.definir_cor(Azul) senao se(matriz[i][j] == 3) g.definir_cor(Vermelho) senao g.definir_cor(Cinza)

			// 6 eh o tamanho individual de cada pixel

			g.desenhar_retangulo(x,y,6,6,falso,verdadeiro)
			x += 6
		}
			x = 100
			y += 6
		}
	}
	
	// Atualiza celula conforme meouse pressionado
	
	funcao vazio atualizarMouse(inteiro &matriz[][]) {
		se(nao(mouse.algum_botao_pressionado())) retorne
		// Declara Posiecoes do mouse
		
		inteiro mouseX = mouse.posicao_x()
		inteiro mouseY = mouse.posicao_y()
		
		// Calcula a posicao da celula, com o -17 para ficar bem na ponta do ponteiro.

		inteiro celulaX = mouseX/6 - 17
		inteiro celulaY = mouseY/6 - 17

		// Verificar se posicao eh valida
		
		se(celulaX < 0 ou celulaX > 99) retorne
		se(celulaY < 0 ou celulaY > 99) retorne

		// Pegar o estado
		inteiro estadoCelula = matriz[celulaY][celulaX]
		
		se(mouse.botao_pressionado(mouse.BOTAO_DIREITO)) {
			matriz[celulaY][celulaX] = 0
			
			desenharMatriz(matriz) 
			g.renderizar()
		}

		se(mouse.botao_pressionado(mouse.BOTAO_ESQUERDO)) {
			matriz[celulaY][celulaX] = 1
			
			desenharMatriz(matriz) 
			g.renderizar()
		}
		
	}

	funcao vazio atalhosTeclado() {
		se(t.tecla_pressionada(t.TECLA_R)) {
			// Reseta o canvas
			inicializarMatriz(Canvas, 0)
			Evolucao = 0

			desenharMatriz(Canvas)
			g.renderizar()
		}

		se(t.tecla_pressionada(t.TECLA_E)) {
			// Aleatoriza o canvas
			inicializarMatriz(Canvas, 1)
			Evolucao = 0

			desenharMatriz(Canvas)
			g.renderizar()
		}
	}
	
	funcao vazio executarAtualizacao(inteiro &matriz[][], inteiro &matrizAuxiliar[][]) {
		//modo de edicao
		enquanto(t.tecla_pressionada(t.TECLA_Q)) atualizarMouse(matriz)

		//evolucao e desenho
		se(Evolucao != 0) evoluir(matriz, matrizAuxiliar)
		desenharMatriz(matrizAuxiliar) 
	}
	
	funcao vazio renderizarCanvas() {
		// Definicoes de variaveis
		cadeia EvolucaoTexto = tipos.inteiro_para_cadeia(Evolucao, 10)
			// Loop entre matrizes
			se(Evolucao % 2 == 0) {
				executarAtualizacao(CanvasAuxiliar, Canvas) 
			}
			se(Evolucao % 2 == 1) {
				executarAtualizacao(Canvas, CanvasAuxiliar) 
			}
			
			g.definir_cor(Verde)
			g.desenhar_texto(50, 50, EvolucaoTexto)
	}

	funcao vazio dialogo() {
		se(Evolucao < 35) g.desenhar_texto(50, 70, "An traveller has come.")
		se(Evolucao > 35 e Evolucao < 60) g.desenhar_texto(50, 70, "An traveller has come..")
		se(Evolucao > 60 e Evolucao < 90) g.desenhar_texto(50, 70, "An traveller has come...")
		se(Evolucao > 90 e Evolucao < 150) g.desenhar_texto(50, 70, "AI : There was an cientist")
		se(Evolucao > 150 e Evolucao < 220) g.desenhar_texto(50, 70, "AI : Working to make life")
		se(Evolucao > 220 e Evolucao < 290) g.desenhar_texto(50, 70, "AI : He failed in his mission")
		se(Evolucao > 290 e Evolucao < 340) g.desenhar_texto(50, 70, "AI : You must continue his legacy")
		se(Evolucao > 340) g.desenhar_texto(80, 50, "Keybinds : Q [Pauses the simulation AND you can change the state of a cell using the mouse]")
		se(Evolucao > 340) g.desenhar_texto(80, 70, "E [Randomizes the canvas] R [Clears the canvas]")
	}
	
	funcao inicio(){
		
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(800, 800)

		inicializarMatriz(Canvas, 0)

		g.definir_titulo_janela("The game of life")



		enquanto(nao t.tecla_pressionada(t.TECLA_ESC)){
			// renderizar
			atalhosTeclado()
			renderizarCanvas()
			dialogo()
			g.renderizar()
			
			Evolucao++
			u.aguarde(12)
		}
	}	
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 1983; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */
