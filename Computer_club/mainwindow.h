#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSqlDatabase>
#include <QMessageBox>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlError>
#include <QVariant>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_ShowClients_clicked();

    void on_ShowClientsPlaces_clicked();

    void on_ShowPlaces_clicked();

    void on_pushButton_3_clicked();

private:
    Ui::MainWindow *ui;
    QSqlQueryModel *model;//указатель на модель
};
#endif // MAINWINDOW_H
