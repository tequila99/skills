# skills

Коллекция скиллов (навыков) для [Claude Code](https://claude.com/claude-code) — переиспользуемых инструкций, которые расширяют поведение Claude под конкретные сценарии работы.

## Состав

| Skill | Команда | Описание |
|---|---|---|
| [study](skills/study/SKILL.md) | `/study [тема]` | Сократовский обучающий режим: вместо готовых ответов Claude задаёт наводящие вопросы и подводит пользователя к решению самостоятельно. Применим и к теории, и к инженерным задачам (отладка, ревью, дизайн). |
| [ideate](skills/ideate/SKILL.md) | `/ideate [название идеи]` | Многосессионный брейнсторминг и разработка технической спецификации: сырые идеи → уточняющие вопросы → `proposal.md` (tech-agnostic) → `techspec.md` (конкретный стек). |

## Установка как плагин Claude Code

Весь набор пакуется как один плагин через манифест в `.claude-plugin/` в корне репозитория.

Внутри Claude Code:

```
/plugin marketplace add tequila99/skills
/plugin install tequila99-skills@tequila99
```

Или из shell:

```bash
claude plugin marketplace add tequila99/skills
claude plugin install tequila99-skills@tequila99
```

## Установка вручную (по отдельности)

### study

Скопировать `skills/study/SKILL.md` в `~/.claude/skills/study/SKILL.md`.

### ideate

`ideate` — самостоятельный подпроект со своим установщиком и собственным манифестом плагина (может быть вынесен в отдельный репозиторий). Подробности в [skills/ideate/README.md](skills/ideate/README.md):

```bash
cd skills/ideate
./install.sh
```

## Структура репозитория

```
.claude-plugin/         # манифест плагина/маркетплейса для всего набора
  plugin.json
  marketplace.json
LICENSE
skills/
  study/
    SKILL.md
  ideate/
    SKILL.md
    README.md
    install.sh
    bin/                  # вспомогательные скрипты (append/init)
    scripts/
    .claude-plugin/       # отдельный манифест — на случай выноса ideate в свой репозиторий
```

## Лицензия

[MIT](LICENSE)
