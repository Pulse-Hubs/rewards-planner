# Rewards Planner

Um painel pessoal e não oficial para acompanhar atividades do Microsoft Rewards, organizar metas de cartões-presente e configurar lembretes.

## Usar

Abra o site público quando o GitHub Pages estiver ativado: https://badybosslelo-jpg.github.io/rewards-planner/

## Publicar no GitHub Pages

Em **Settings → Pages → Build and deployment**:

1. Em **Source**, selecione **Deploy from a branch**.
2. Em **Branch**, selecione **main** e **/(root)**.
3. Clique em **Save**.

O site é 100% estático. Todo o CSS e JavaScript estão no `index.html`, sem necessidade de instalar dependências ou configurar serviços externos.

## Funcionalidades

- Checklist das **categorias de atividades para conferir**, com atalhos oficiais.
- Acompanhamento manual de saldo de pontos e meta de recompensa.
- Atividades personalizadas e histórico dos últimos 7 dias.
- Lembretes no navegador **enquanto a página estiver aberta**.
- Exportação de lembrete recorrente para calendário (`.ics`).
- Layout responsivo para celular e computador.

## Privacidade e limitações

Este repositório e o site são **públicos**, sem proteção por senha, conforme solicitado. Qualquer pessoa pode acessar o painel, mas os registros pessoais ficam no `localStorage` do navegador de cada visitante, e não são compartilhados entre dispositivos ou enviados ao GitHub. Não insira credenciais em campos do site nem no repositório.

O site **não** autentica sua conta Microsoft, não automatiza pesquisas ou coleta de pontos, não verifica automaticamente missões elegíveis nem confirma pontos. Para conferir atividades e resgatar recompensas, acesse https://rewards.microsoft.com/.

Projeto independente, sem afiliação com a Microsoft.
