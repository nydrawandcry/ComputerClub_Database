#include "mainwindow.h"
#include "addclient.h"
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
            on_ShowClients_clicked(); // обновляем таблицу
        }
    }



}

