# Семейный офис — ИИ-агент для портфеля российских акций

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) ![Agent Skills](https://img.shields.io/badge/Agent%20Skills-SKILL.md-0E7A5C) ![Python](https://img.shields.io/badge/python-3.9%2B-3776AB?logo=python&logoColor=white) ![Hermes Agent](https://img.shields.io/badge/Hermes%20Agent-ready-555) ![OpenClaw](https://img.shields.io/badge/OpenClaw-ready-555) ![Claude Code](https://img.shields.io/badge/Claude%20Code-ready-D97757) ![Codex CLI](https://img.shields.io/badge/Codex%20CLI-ready-555)

**Открытый ИИ-агент для ведения портфеля акций Мосбиржи** для Hermes Agent, OpenClaw, Claude Code и Codex CLI: ежедневный брифинг после закрытия торгов, недельный обзор против IMOEX, риск, дивиденды и отсечки, инвесткомитет по событиям.

[Презентация агента](https://ildargiv.github.io/ru-portfolio-agent/) · [English](#english) · [Семейство агентов](#семейство-агентов) · [Установка](#установка)

![Семейный офис: ИИ-агент для портфеля акций Мосбиржи, брифинг по сессии против IMOEX](docs/preview.png)

Как будто у вас есть семейный офис с лучшими управляющими: вы даёте список своих акций, а команда каждый день следит за ними и докладывает.

- **Портфель одной строкой.** «Мой портфель: SBER, LKOH, MGNT». Количество и средняя цена необязательны (`SBER:100@285`); если их дать, агент считает стоимость и P&L. Сделки — словами: «купил ещё 50 Сбера по 300».
- **Ежедневный брифинг после закрытия биржи.** Команда офиса — CIO, трейдер, аналитики по бумагам, риск-менеджер, офицер корпоративных событий и дивидендов, макростратег, адвокат дьявола — разбирает торги по каждой бумаге: движение против IMOEX и сектора, обороты, гэпы, 52-недельные уровни, 200-дневная средняя, отсечки с последним днём покупки, проверенные новости и раскрытие, концентрация. Объясняет, почему бумага двигалась, и задаёт один неудобный вопрос. В тихий день — три строки.
- **Недельный обзор.** Доходность портфеля против IMOEX за неделю, месяц, квартал, год и с начала года; волатильность, бета, просадка, связанные бумаги, вклад каждой позиции, «здоровье» тезисов, календарь на две недели.
- **Инвесткомитет по бумаге.** Если событие задевает тезис (отчёт, смена дивполитики, движение больше 15%, сработал триггер), созывается комитет: независимые мнения экспертов, атака адвоката дьявола, оценка (мультипликаторы, DCF, обратный DCF, дивмодель), голосование, решение CIO с триггерами пересмотра.
- **Папка на каждую бумагу.** Отчёты МСФО/РСБУ, новости, история цен и дивидендов, тезис, протоколы — всё копится в `~/family-office/<ТИКЕР>/`, и каждый следующий разбор опирается на предыдущий.

## Состав
```
SOUL.md                                личность агента (Hermes, OpenClaw)
AGENTS.md                              инструкция для OpenClaw, Codex, Cursor и др.
agents/claude-code/portfolio.md        субагент «глава семейного офиса» для Claude Code
agents/claude-code/portfolio-devil.md  субагент «адвокат дьявола»
install.sh / install.ps1               установка (Linux/macOS/WSL и Windows)
skills/finance/ru-portfolio/
  SKILL.md                             процедуры: состав портфеля, брифинг, недельный обзор, комитет, расписание
  references/
    family-office.md                   команда офиса, ежедневный брифинг, недельный обзор, эскалация
    expert-panel.md                    инвесткомитет: роли, порядок заседания, голосование
    report-template.md                 брифинг, сообщение владельцу, обзор, протокол комитета
    analysis-framework.md              методология: бизнес, финансы, оценка, дивиденды, корпоративное управление РФ
    desk-structure.md                  что лежит в хранилище
    data-sources.md / reading-reports.md / news-forums.md
  scripts/
    portfolio.py                       портфель, сделки, разбор торговой сессии, недельный обзор
    news.py                            новости по бумагам без дублей
    desk.py                            папки бумаг, хронология, итоги комитета
    moex_share.py                      карточка бумаги: рынок, доходность против IMOEX, дивиденды
    gir_bo.py / report_extract.py      РСБУ из ГИР БО, чтение PDF-отчётов
    valuation.py                       мультипликаторы, DCF, обратный DCF, модель Гордона
```

## Хранилище
```
~/family-office/
  portfolio.json      ваш портфель                 watchlist.json   все бумаги с папками
  _portfolio/
    briefs/           ежедневные брифинги          reviews/         недельные обзоры
    daily/            данные разбора сессий        history.csv      день портфеля против IMOEX
    journal.md        хронология портфеля
  SBER/               README, thesis, journal, analyses/, market/, financials/, reports/, news/, forums/
```
Корень меняется переменной `FAMILY_OFFICE`. Если у вас стоит ru-stocks-agent, можно указать `FAMILY_OFFICE` = его `STOCKS_DESK`: структура папок совместима, оба агента будут работать с одними и теми же папками.

## Установка
```bash
git clone https://github.com/ildargiv/ru-portfolio-agent.git && cd ru-portfolio-agent
```
| Среда | Команда | Что получаете |
|---|---|---|
| Hermes Agent (Windows) | `powershell -ExecutionPolicy Bypass -File install.ps1 hermes-default` | навык в основном профиле (`%LOCALAPPDATA%\hermes` или `HERMES_HOME`); `install.ps1 hermes` — в профиль `portfolio`, если он есть |
| Hermes Agent (Linux/macOS/WSL2) | `./install.sh` или `./install.sh hermes-default` | профиль `portfolio` с характером из SOUL.md (`portfolio chat`), либо навык в основном профиле |
| OpenClaw | `./install.sh openclaw` (Windows: `install.ps1 openclaw`) | навык `ru-portfolio`; характер — добавить SOUL.md в workspace |
| Claude Code | `./install.sh claude` (Windows: `install.ps1 claude`) | навык + субагенты `portfolio` и `portfolio-devil` |
| Codex CLI | `./install.sh codex` | навык; также читает `AGENTS.md` |

Нужен Python 3.9+ (только стандартная библиотека) и `pypdf` для чтения PDF. В Windows скрипты запускаются через `py`, `python` или `python3`.

## Первый запуск
1. Скажите агенту: «Мой портфель: SBER, LKOH, MGNT, TATNP» (можно с количеством и средней ценой). Подойдёт и выгрузка брокера: CSV, XLSX, PDF или скриншот.
2. Агент заведёт папки и по очереди проведёт первичные разборы комитетом, начиная с самой крупной позиции.
3. Включите расписание (время московское):

| Среда | Ежедневный брифинг, будни 19:15 |
|---|---|
| Hermes | Попросите в чате: «каждый будний день в 19:15 присылай брифинг по портфелю, по субботам в 10:00 — недельный обзор». Или командой: `hermes cron create "15 19 * * 1-5" "Используй навык ru-portfolio, процедура 2: ежедневный брифинг семейного офиса по моему портфелю. Сохрани брифинг и пришли короткое сообщение" --skill ru-portfolio --name "Брифинг портфеля" --timezone Europe/Moscow`. Задания выполняет шлюз: `hermes gateway` должен работать (`hermes gateway install` — как служба) |
| OpenClaw | `openclaw cron add "15 19 * * 1-5" "<тот же текст>" --name "Брифинг портфеля" --tz Europe/Moscow` (нужен запущенный Gateway) |
| Claude | задача по расписанию в приложении Claude или `/schedule` в Claude Code с тем же текстом |

Недельный обзор: `"0 10 * * 6"` и «…процедура 3: недельный обзор портфеля».

![Пример ежедневного брифинга: разбор торговой сессии демо-портфеля и сообщение владельцу](docs/answer.png)

## Примеры запросов
- «Мой портфель: SBER:100@285, LKOH:5@6900, MGNT»
- «Что с портфелем сегодня?» · «Почему упал Магнит?»
- «Купил ещё 50 Сбера по 300» · «Продал половину Лукойла по 7200»
- «Недельный обзор» · «Не слишком ли у меня много нефтянки?»
- «Разбери Татнефть комитетом: держать или сокращать?»
- «Вышел отчёт МТС — что это значит для моей позиции?»

## Проверка скриптов вручную
```bash
S=skills/finance/ru-portfolio/scripts
python3 $S/portfolio.py set "SBER:100@285, LKOH:5@6900" MGNT
python3 $S/portfolio.py session --save
python3 $S/news.py SBER LKOH MGNT --days 3
python3 $S/portfolio.py review
```

## Семейство агентов
Каждый агент живёт в своём репозитории и ставится отдельно. Если нужен ещё один, установите его рядом, одной командой (для Claude Code: `./install.sh claude`, для Hermes: `./install.sh`):

| Агент | Для чего | Установка |
|---|---|---|
| [Инвесткомитет · ru-stocks-agent](https://github.com/ildargiv/ru-stocks-agent) | анализ акций Мосбиржи: список наблюдения, папка на акцию, инвесткомитет с адвокатом дьявола | `git clone https://github.com/ildargiv/ru-stocks-agent.git && cd ru-stocks-agent && ./install.sh claude` |
| [Облигационер · ru-bonds-agent](https://github.com/ildargiv/ru-bonds-agent) | облигации РФ: ОФЗ и корпоративные выпуски, YTM, дюрация, кредитный скоринг, скринер | `git clone https://github.com/ildargiv/ru-bonds-agent.git && cd ru-bonds-agent && ./install.sh claude` |
| [Семейный офис · ru-portfolio-agent](https://github.com/ildargiv/ru-portfolio-agent) | портфель акций: ежедневный брифинг после закрытия биржи, недельный обзор против IMOEX | `git clone https://github.com/ildargiv/ru-portfolio-agent.git && cd ru-portfolio-agent && ./install.sh claude` |
| [FinEx · finex-agent](https://github.com/ildargiv/finex-agent) | пайщикам фондов FinEx в ликвидации: документы, новости, модель выплаты на пай | `git clone https://github.com/ildargiv/finex-agent.git && cd finex-agent && ./install.sh claude` |

## English
**Family Office (ru-portfolio-agent)** is an open-source AI agent skill that runs a portfolio of Russian stocks (Moscow Exchange, MOEX) like a small family office. Give it your tickers once; after every trading session it reviews each holding against the IMOEX index and its sector (volume, gaps, 52-week levels, 200-day average, dividend record dates, verified news), sends a short briefing, and publishes a weekly review (returns vs IMOEX, volatility, beta, drawdown, attribution, thesis health). Material events trigger a full investment committee with a devil's advocate. Built on the open Agent Skills standard (SKILL.md); works in Hermes Agent, OpenClaw, Claude Code and Codex CLI. Your portfolio stays on your computer. The agent answers in Russian. Analytics only, not investment advice.

## Лицензия
MIT, см. [LICENSE](LICENSE).

**Важно.** Агент даёт аналитику и образовательную информацию. Это не индивидуальная инвестиционная рекомендация и не финансовый совет. Решения об инвестициях и ответственность за них — на пользователе. Агент может ошибаться: проверяйте ключевые цифры по первоисточникам.
