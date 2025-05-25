#include "mainwindow.h"
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



