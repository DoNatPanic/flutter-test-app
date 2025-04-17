# Мобильное приложение для просмотра новостей

[![provider](https://img.shields.io/badge/provider-6.1.2-blue.svg)](https://pub.dev/packages/provider)
[![shared_preferences](https://img.shields.io/badge/shared__preferences-2.5.2-blue.svg)](https://pub.dev/packages/shared_preferences)
[![go_router](https://img.shields.io/badge/go__router-14.8.1-blue.svg)](https://pub.dev/packages/go_router)
[![http](https://img.shields.io/badge/http-1.3.0-green.svg)](https://pub.dev/packages/http)
[![flutter_dotenv](https://img.shields.io/badge/flutter__dotenv-5.0.2-lightgrey.svg)](https://pub.dev/packages/flutter_dotenv)
[![floor](https://img.shields.io/badge/floor-1.5.0-yellow.svg)](https://pub.dev/packages/floor)

## Описание проекта

Приложение предоставляет функциональность для поиска новостей, детального просмотра, и добавления комментариев. Новости запршиваются через API https://newsapi.org/, комментарии сохраняются в локальную БД SQLite.

## 📱 Основные функции

-   🔍 Поиск новостей по ключевым словам
-   💼 Просмотр детальной информации о новости
-   🎙️ Добавление комментария к новости

## 🛠 Технологический стек

| Категория              | Технологии                   |
| ---------------------- | ---------------------------- |
| Язык                   | Flutter/Dart                 |
| Архитектура            | MVVM + Clean Architecture    |
| DI                     | Manual Dependency Injection  |
| Сетевые запросы        | http                         |
| Асинхронность          | Future-based                 |
| Локальная БД           | Floor                        |
| Хранение данных        | Shared Preferences           |
| Навигация              | GoRouter                     |

## 💻 Demo

![Демонстрация работы приложения](./images/demo.gif)

## 🚀 Инструкция по запуску

1. **Склонируйте репозиторий**:

    ```bash
    git clone https://github.com/DoNatPanic/flutter-test-app.git
    ```

2. **Добавьте API-ключ**:

    - Создайте файл `.env` в корне проекта
    - Добавьте строку:
        ```properties
        API_KEY=токен_для_доступа_к_api
        ```

3. **Запустите в VS Code**:
    - Откройте проект
    - Дождитесь синхронизации
    - Нажмите `Run` для сборки и запуска
