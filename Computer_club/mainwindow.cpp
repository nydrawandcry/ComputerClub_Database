#include "mainwindow.h"
#include "addclient.h"
#include "addplace.h"
#include "addsession.h"
#include "editclient.h"
#include "editplace.h"
#include "editsession.h"
#include "qdatetime.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    model = new QSqlQueryModel(this);
    ui->Browser->setModel(model);

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("E:/2kurs/4sem/db/my_database/comp_club_db.sqlite");

    if (!db.open())
    {
        QMessageBox::critical(this, "Ошибка", "Не удалось подключиться к базе данных");
        return;
    }

    loadClientsBalance();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_ShowClients_clicked()
{
    model->setQuery("SELECT * FROM client");

    if(model->lastError().isValid())
    {
        QMessageBox::critical(this, "Ошибка в показе клиентов компьютерного клуба.", model->lastError().text());
    }
}

void MainWindow::on_ShowClientsPlaces_clicked()
{
    model->setQuery("SELECT * FROM client_rents_gaming_place");

    if(model->lastError().isValid())
    {
        QMessageBox::critical(this, "Ошибка в показе клиентов компьютерного клуба и арендованных ими игровых мест.", model->lastError().text());
    }
}

void MainWindow::on_ShowPlaces_clicked()
{
    model->setQuery("SELECT * FROM gaming_place");

    if(model->lastError().isValid())
    {
        QMessageBox::critical(this, "Ошибка в показе игровых мест компьютерного клуба.", model->lastError().text());
    }
}

void MainWindow::loadClientsBalance()
{
    QSqlQuery query("SELECT id, name FROM client");

    while (query.next())
    {
        int id = query.value(0).toInt();
        QString name = query.value(1).toString();

        ui->BalanceClient->addItem(name, id);
        ui->ClientBalanceMinus->addItem(name,id);
        //ui->->addItem(name,id);
    }
}

void MainWindow::on_addClient_clicked()
{
    addclient dialog(this);

    if(dialog.exec() == QDialog::Accepted)
    {
        QString name = dialog.getName();
        int age = dialog.getAge();
        QString phone = dialog.getPhone();
        double balance = dialog.getBalance();
        QString status = dialog.getStatus();

        QSqlQuery query;

        query.prepare("INSERT INTO client (name, age, phone, balance, status) VALUES (?, ?, ?, ?, ?)");
        query.addBindValue(name);
        query.addBindValue(age);
        query.addBindValue(phone);
        query.addBindValue(balance);
        query.addBindValue(status);

        if (!query.exec())
        {
            QMessageBox::critical(this, "Ошибка при добавлении клиента", query.lastError().text());
        }
        else
        {
            QMessageBox::information(this, "Успех", "Клиент добавлен");
            on_ShowClients_clicked();
        }
    }
}

void MainWindow::on_EditClient_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Предупреждение", "Сначала выберите клиента для редактирования");
        return;
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    QString name = model->index(row, 1).data().toString();
    int age = model->index(row, 2).data().toInt();
    QString phone = model->index(row, 3).data().toString();
    double balance = model->index(row, 4).data().toDouble();
    QString status = model->index(row, 5).data().toString();

    int client_id = model->index(row, 0).data().toInt();

    editclient dialog(this);

    dialog.setClientData(name, age, phone, balance, status);

    if(dialog.exec()== QDialog::Accepted)
    {
        QString newName = dialog.getName();
        int newAge = dialog.getAge();
        QString newPhone = dialog.getPhone();
        double newBalance = dialog.getBalance();
        QString newStatus = dialog.getStatus();

        QSqlQuery query;

        query.prepare("UPDATE client SET name = ?, age = ?, phone = ?, balance = ?, status = ? WHERE id = ?");
        query.addBindValue(newName);
        query.addBindValue(newAge);
        query.addBindValue(newPhone);
        query.addBindValue(newBalance);
        query.addBindValue(newStatus);
        query.addBindValue(client_id);

        if(!query.exec())
        {
            QMessageBox::critical(this, "Ошибка при редактировании клиента", query.lastError().text());
        }
        else
        {
            QMessageBox::information(this, "Успех", "Клиент успешно редактирован");
            on_ShowClients_clicked();
        }
    }
}

void MainWindow::on_DeleteClient_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Ошибка", "Сначала выберите клиента для удаления");
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    int client_id = model->index(row, 0).data().toInt();

    auto reply = QMessageBox::question(this, "Подтверждение удаления", "Вы действительно хотите удалить этого пользователя?", QMessageBox::No | QMessageBox::Yes);

    if(reply == QMessageBox::No)
    {
        return;
    }

    QSqlQuery query;

    query.prepare("DELETE FROM client WHERE id = ?");

    query.addBindValue(client_id);

    if(!query.exec())
    {
        QMessageBox::critical(this, "Ошибка удаления", query.lastError().text());
    }
    else
    {
        QMessageBox::information(this, "Успех", "Клиент успешно удален из базы данных");
        on_ShowClients_clicked();
    }
}

void MainWindow::on_AddPlace_clicked()
{
    addplace dialog(this);

    if(dialog.exec() == QDialog::Accepted)
    {
        QString type = dialog.getType();

        QSqlQuery query;

        query.prepare("INSERT INTO gaming_place(type) VALUES(?)");

        query.addBindValue(type);

        if(!query.exec())
        {
            QMessageBox::critical(this, "Ошибка при добавлении игрового места", query.lastError().text());
        }
        else
        {
            QMessageBox::information(this, "Успех", "Игровое место добавлено");
            on_ShowPlaces_clicked();
        }
    }
}

void MainWindow::on_EditPlace_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Предупреждение", "Сначала выберите игровое место для редактирования");
        return;
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    QString type = model->index(row, 1).data().toString();

    int place_id = model->index(row, 0).data().toInt();

    editplace dialog(this);

    dialog.setPlaceData(type);

    if(dialog.exec() == QDialog::Accepted)
    {
        QSqlQuery query;

        QString newType = dialog.getType();

        query.prepare("UPDATE gaming_place SET type = ? WHERE id = ?");

        query.addBindValue(newType);

        query.addBindValue(place_id);

        if(!query.exec())
        {
            QMessageBox::critical(this, "Ошибка при редактировании игрового места", query.lastError().text());
        }
        else
        {
            QMessageBox::information(this, "Успех", "Игровое место обновлено");
            on_ShowPlaces_clicked();
        }
    }
}

void MainWindow::on_DeletePlace_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Предупреждение", "Сначала выберите игровое место для удаления");
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    int place_id = model->index(row, 0).data().toInt();

    auto reply = QMessageBox::question(this, "Подтверждение удаления", "Вы точно хотите удалить это игровое место?", QMessageBox::No | QMessageBox::Yes);

    if(reply == QMessageBox::No)
    {
        return;
    }

    QSqlQuery query;

    query.prepare("DELETE FROM gaming_place WHERE id = ?");

    query.addBindValue(place_id);

    if(!query.exec())
    {
        QMessageBox::critical(this, "Ошибка при удалении игрового места", query.lastError().text());
    }
    else
    {
        QMessageBox::information(this, "Успех", "Игровое место удалено");
        on_ShowPlaces_clicked();
    }
}

void MainWindow::on_AddSession_clicked()
{
    addsession dialog(this);

    if(dialog.exec() == QDialog::Accepted)
    {
        int clientId = dialog.getClientId();
        int placeId = dialog.getPlaceId();
        QTime sessionStart = dialog.getSessionStart();
        QTime sessionEnd = dialog.getSessionEnd();

        //сначала проверка, уникально ли игровое место
        // Проверка на пересекающиеся сессии по времени
        QSqlQuery check;
        check.prepare(R"(
            SELECT COUNT(*)
            FROM client_rents_gaming_place
            WHERE gaming_place_id = ?
              AND NOT (
                  session_end <= ? OR session_start >= ?
              )
        )");

        check.addBindValue(placeId);
        check.addBindValue(sessionStart.toString("HH:mm:ss"));  // session_end <= start
        check.addBindValue(sessionEnd.toString("HH:mm:ss"));    // session_start >= end

        if (!check.exec())
        {
            QMessageBox::warning(this, "Ошибка", "Не удалось проверить занятость игрового места:\n" + check.lastError().text());
            return;
        }

        check.next();
        int conflicts = check.value(0).toInt();

        if (conflicts > 0)
        {
            QMessageBox::warning(this, "Место занято", "Игровое место уже занято в это время.");
            return;
        }

        // Вставка новой сессии
        QSqlQuery insert;
        insert.prepare(R"(
            INSERT INTO client_rents_gaming_place (client_id, gaming_place_id, session_start, session_end)
            VALUES (?, ?, ?, ?)
        )");

        insert.addBindValue(clientId);
        insert.addBindValue(placeId);
        insert.addBindValue(sessionStart.toString("HH:mm:ss"));
        insert.addBindValue(sessionEnd.toString("HH:mm:ss"));

        if (!insert.exec())
        {
            QMessageBox::critical(this, "Ошибка при добавлении сессии", insert.lastError().text());
            return;
        }
        else
        {
            QMessageBox::information(this, "Успех", "Сессия успешно добавлена.");
            on_ShowClientsPlaces_clicked();
        }
    }
}

void MainWindow::on_EditSession_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Ошибка", "Выберите сессию для редактирования");
        return;
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    editsession dialog(this);

    int clientId = model->index(row, 0).data().toInt();
    int placeId = model->index(row, 1).data().toInt();
    QTime sessionStart = QTime::fromString(model->index(row, 2).data().toString(), "hh:mm:ss");
    QTime sessionEnd = QTime::fromString(model->index(row,3).data().toString(), "hh:mm:ss");

    dialog.setClientPLaceData(clientId, placeId, sessionStart, sessionEnd);

    if(dialog.exec()== QDialog::Accepted)
    {
        int newClient = dialog.getClientId();
        int newPlace = dialog.getPlaceId();
        QTime newSessionStart = dialog.getSessionStart();
        QTime newSessionEnd = dialog.getSessionEnd();
        //=====================CHECK=====================

        QSqlQuery check;
        check.prepare("SELECT COUNT(*) FROM client_rents_gaming_place WHERE gaming_place_id = ? AND client_id != ?");
        check.addBindValue(newPlace);
        check.addBindValue(newClient);

        if(!check.exec())
        {
            QMessageBox::critical(this, "Ошибка с проверкой на занятость игрового места", check.lastError().text());
            return;
        }
        if(check.next())
        {
            int count = check.value(0).toInt();
            if(count>0)
            {
                QMessageBox::warning(this, "Занято", "Данное игровое место уже занято другим пользователем. Выберете другое");
                return;
            }
        }

        //=====================CHECK=====================
        QSqlQuery update;
        update.prepare(R"(
            UPDATE client_rents_gaming_place
            SET client_id = ?, gaming_place_id = ?, session_start = ?, session_end = ?
            WHERE client_id = ? AND gaming_place_id = ?
        )");

        update.addBindValue(newClient);
        update.addBindValue(newPlace);
        update.addBindValue(newSessionStart.toString("hh:mm:ss"));
        update.addBindValue(newSessionEnd.toString("hh:mm:ss"));

        if(!update.exec())
        {
            QMessageBox::critical(this, "Ошибка с редактированием сессии", update.lastError().text());
        }
        else
        {
            QMessageBox::information(this, "Успех", "Сессия обновлена");
            on_ShowClientsPlaces_clicked();
        }
    }
}

void MainWindow::on_DeleteSession_clicked()
{
    QModelIndex str_index = ui->Browser->currentIndex();

    if(!str_index.isValid())
    {
        QMessageBox::warning(this, "Ошибка", "Сначала выберите сессию для удаления");
        return;
    }

    int row = str_index.row();
    QAbstractItemModel *model = ui->Browser->model();

    int client = model->index(row, 0).data().toInt();
    int place = model->index(row, 1).data().toInt();

    auto reply = QMessageBox::question(this, "Подтверждение", "Вы действительно хотите удалить сессию?", QMessageBox::No | QMessageBox::Yes);

    if(reply == QMessageBox::No)
    {
        return;
    }

    QSqlQuery query;

    query.prepare("DELETE FROM client_rents_gaming_place WHERE client_id = ? AND gaming_place_id = ?");

    query.addBindValue(client);
    query.addBindValue(place);

    if(!query.exec())
    {
        QMessageBox::critical(this, "Ошибка при удалении сессии", query.lastError().text());
    }
    else
    {
        QMessageBox::information(this, "Успех", "Сессия удалена");
        on_ShowClientsPlaces_clicked();
    }
}



void MainWindow::on_AddBalance_clicked()
{
    int clientId = ui->BalanceClient->currentData().toInt();
    QString clientName = ui->BalanceClient->currentText();
    double amount = ui->AddBalanceSum->value();

    if (amount <= 0)
    {
        QMessageBox::warning(this, "Ошибка", "Введите сумму пополнения");
        return;
    }

    QSqlQuery updateQuery;
    updateQuery.prepare("UPDATE client SET balance = balance + ? WHERE id = ?");
    updateQuery.addBindValue(amount);
    updateQuery.addBindValue(clientId);

    if (!updateQuery.exec())
    {
        QMessageBox::critical(this, "Ошибка", "Ошибка при обновлении баланса");
        return;
    }
    else
    {
        QMessageBox::information(this, "Успех", "Баланс обновлен");
        on_ShowClients_clicked();
    }
}

void MainWindow::on_MinusBalance_clicked()
{
    int clientId = ui->ClientBalanceMinus->currentData().toInt();
    QString clientName = ui->ClientBalanceMinus->currentText();
    double amount = ui->MinusBalanceAmount->value();

    if (amount <= 0)
    {
        QMessageBox::warning(this, "Ошибка", "Введите сумму пополнения");
        return;
    }

    QSqlQuery updateQuery;
    updateQuery.prepare("UPDATE client SET balance = balance - ? WHERE id = ?");
    updateQuery.addBindValue(amount);
    updateQuery.addBindValue(clientId);

    if (!updateQuery.exec())
    {
        QMessageBox::critical(this, "Ошибка", "Ошибка при обновлении баланса");
        return;
    }
    else
    {
        QMessageBox::information(this, "Успех", "Баланс обновлен");
        on_ShowClients_clicked();
    }
}

void MainWindow::on_AutoCount_clicked()
{
    //int clientId = ui->ClientAuto->currentData().toInt();
    QTime startTime = ui->startAuto->time();
    QTime endTime = ui->EndAuto->time();

    if (startTime >= endTime)
    {
        QMessageBox::warning(this, "Ошибка", "Время окончания должно быть позже начала.");
        return;
    }

    int durationMinutes = startTime.secsTo(endTime) / 60;
    double costPerHour = 100.0; // например, 100 руб/час
    double cost = (durationMinutes / 60.0) * costPerHour;

    ui->Results->setText(QString("Длительность: %1 мин\nСтоимость: %2 руб.")
                             .arg(durationMinutes)
                             .arg(QString::number(cost, 'f', 2)));
}

void MainWindow::on_BalanceClient_currentIndexChanged(int index)
{
    int clientId = ui->BalanceClient->itemData(index).toInt();

    QSqlQuery query("SELECT balance FROM client WHERE id = ?");
    query.addBindValue(clientId);

    if(query.exec() && query.next())
    {
        double clientBalance = query.value(0).toDouble();
        ui->CurrentBalance->setText(QString::number(clientBalance, 'f', 2));
    }
    else
    {
        ui->CurrentBalance->setText("Ошибка при отображении текущего баланса клиента");
    }
}

void MainWindow::on_ClientBalanceMinus_currentIndexChanged(int index)
{
    int clientId = ui->ClientBalanceMinus->itemData(index).toInt();

    QSqlQuery query("SELECT balance FROM client WHERE id = ?");
    query.addBindValue(clientId);

    if(query.exec() && query.next())
    {
        double clientBalance = query.value(0).toDouble();
        ui->CurrentBalanceMinus->setText(QString::number(clientBalance, 'f', 2));
    }
    else
    {
        ui->CurrentBalance->setText("Ошибка при отображении текущего баланса клиента");
    }
}
