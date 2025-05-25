#include "mainwindow.h"
#include "addclient.h"
#include "editclient.h"
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
        query.addBindValue(dialog.getName());
        query.addBindValue(age);
        query.addBindValue(phone);
        query.addBindValue(balance);
        query.addBindValue(status);

        if (!query.exec())
        {
            QMessageBox::critical(this, "Ошибка при добавлении клиента", query.lastError().text());
        } else
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
        QMessageBox::warning(this, "Ошибка", "Сначала выберите клиента для редактирования");
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

