using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace arenda
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private string connectionString = "Server=DESKTOP-VVN5VCI\\SQLEXPRESS;Database=Аренда;Integrated Security=True";
        public MainWindow()
        {
            InitializeComponent();
            data();
        }
        private void data()
        {
            try
            {
                // Загрузка недвижимости
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT н.id_недвижимости, н.Адрес, т.НазваниеТипа, н.Площадь, н.КоличествоКомнат, 
                                    с.НазваниеСтатуса, н.Цена 
                                    FROM Недвижимость н
                                    JOIN ТипыНедвижимости т ON н.id_типа = т.id_типа
                                    JOIN СтатусыНедвижимости с ON н.id_статуса = с.id_статуса";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    НедвижимостьGrid.ItemsSource = dt.DefaultView;
                }

                // Загрузка арендаторов
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Арендаторы";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    АрендаторыGrid.ItemsSource = dt.DefaultView;
                }

                // Загрузка договоров
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT д.id_договора, н.Адрес, 
                                    а.Фамилия + ' ' + а.Имя + ' ' + ISNULL(а.Отчество, '') as АрендаторФИО,
                                    д.ДатаНачала, д.ДатаОкончания, д.ЕжемесячнаяПлата
                                    FROM ДоговорыАренды д
                                    JOIN Недвижимость н ON д.id_недвижимости = н.id_недвижимости
                                    JOIN Арендаторы а ON д.id_арендатора = а.id_арендатора";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    ДоговорыGrid.ItemsSource = dt.DefaultView;
                }

                // Загрузка платежей
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT п.id_платежа, п.ДатаПлатежа, п.Сумма, 
                                    т.НазваниеТипа, с.НазваниеСтатуса, п.Описание
                                    FROM Платежи п
                                    JOIN ТипыПлатежей т ON п.id_типа = т.id_типа
                                    JOIN СтатусыПлатежей с ON п.id_статуса = с.id_статуса";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    ПлатежиGrid.ItemsSource = dt.DefaultView;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ОбновитьДанные_Click(object sender, RoutedEventArgs e)
        {
            data();
        }

        private void ДобавитьНедвижимость_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new НедвижимостьРедактор();
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Недвижимость 
                                        (id_владельца, id_типа, id_статуса, Адрес, Площадь, КоличествоКомнат, 
                                         Этаж, Описание, Цена)
                                        VALUES (@id_владельца, @id_типа, 1, @Адрес, @Площадь, @КоличествоКомнат, 
                                                @Этаж, @Описание, @Цена)";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_владельца", dialog.id_владельца);
                        command.Parameters.AddWithValue("@id_типа", dialog.id_типа);
                        command.Parameters.AddWithValue("@Адрес", dialog.Адрес);
                        command.Parameters.AddWithValue("@Площадь", dialog.Площадь);
                        command.Parameters.AddWithValue("@КоличествоКомнат", dialog.КоличествоКомнат);
                        command.Parameters.AddWithValue("@Этаж", (object)dialog.Этаж ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Описание", (object)dialog.Описание ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Цена", dialog.Цена);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при добавлении недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void РедактироватьНедвижимость_Click(object sender, RoutedEventArgs e)
        {
            if (НедвижимостьGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите недвижимость для редактирования", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)НедвижимостьGrid.SelectedItem;
            int id_недвижимости = (int)row["id_недвижимости"];

            var dialog = new НедвижимостьРедактор(id_недвижимости);
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE Недвижимость 
                                        SET id_владельца = @id_владельца, 
                                            id_типа = @id_типа, 
                                            Адрес = @Адрес, 
                                            Площадь = @Площадь, 
                                            КоличествоКомнат = @КоличествоКомнат, 
                                            Этаж = @Этаж, 
                                            Описание = @Описание, 
                                            Цена = @Цена 
                                        WHERE id_недвижимости = @id_недвижимости";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_недвижимости", id_недвижимости);
                        command.Parameters.AddWithValue("@id_владельца", dialog.id_владельца);
                        command.Parameters.AddWithValue("@id_типа", dialog.id_типа);
                        command.Parameters.AddWithValue("@Адрес", dialog.Адрес);
                        command.Parameters.AddWithValue("@Площадь", dialog.Площадь);
                        command.Parameters.AddWithValue("@КоличествоКомнат", dialog.КоличествоКомнат);
                        command.Parameters.AddWithValue("@Этаж", (object)dialog.Этаж ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Описание", (object)dialog.Описание ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Цена", dialog.Цена);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при обновлении недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void УдалитьНедвижимость_Click(object sender, RoutedEventArgs e)
        {
            if (НедвижимостьGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите недвижимость для удаления", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)НедвижимостьGrid.SelectedItem;
            int id_недвижимости = (int)row["id_недвижимости"];

            if (MessageBox.Show("Вы уверены, что хотите удалить выбранную недвижимость?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = "DELETE FROM Недвижимость WHERE id_недвижимости = @id_недвижимости";
                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_недвижимости", id_недвижимости);

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Недвижимость успешно удалена", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                            data();
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }
     

  private void ДобавитьАрендатора_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new АрендаторРедактор();
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Арендаторы 
                                        (Фамилия, Имя, Отчество, Телефон, ЭлектроннаяПочта, ПаспортныеДанные)
                                        VALUES (@Фамилия, @Имя, @Отчество, @Телефон, @ЭлектроннаяПочта, @ПаспортныеДанные)";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@Фамилия", dialog.Фамилия);
                        command.Parameters.AddWithValue("@Имя", dialog.Имя);
                        command.Parameters.AddWithValue("@Отчество", (object)dialog.Отчество ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Телефон", dialog.Телефон);
                        command.Parameters.AddWithValue("@ЭлектроннаяПочта", (object)dialog.ЭлектроннаяПочта ?? DBNull.Value);
                        command.Parameters.AddWithValue("@ПаспортныеДанные", dialog.ПаспортныеДанные);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при добавлении арендатора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

    private void РедактироватьАрендатора_Click(object sender, RoutedEventArgs e)
        {
            if (АрендаторыGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите арендатора для редактирования", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)АрендаторыGrid.SelectedItem;
            int id_арендатора = (int)row["id_арендатора"];

            var dialog = new АрендаторРедактор(id_арендатора);
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE Арендаторы 
                                        SET Фамилия = @Фамилия, 
                                            Имя = @Имя, 
                                            Отчество = @Отчество, 
                                            Телефон = @Телефон, 
                                            ЭлектроннаяПочта = @ЭлектроннаяПочта, 
                                            ПаспортныеДанные = @ПаспортныеДанные
                                        WHERE id_арендатора = @id_арендатора";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_арендатора", id_арендатора);
                        command.Parameters.AddWithValue("@Фамилия", dialog.Фамилия);
                        command.Parameters.AddWithValue("@Имя", dialog.Имя);
                        command.Parameters.AddWithValue("@Отчество", (object)dialog.Отчество ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Телефон", dialog.Телефон);
                        command.Parameters.AddWithValue("@ЭлектроннаяПочта", (object)dialog.ЭлектроннаяПочта ?? DBNull.Value);
                        command.Parameters.AddWithValue("@ПаспортныеДанные", dialog.ПаспортныеДанные);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при обновлении арендатора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void УдалитьАрендатора_Click(object sender, RoutedEventArgs e)
        {
            if (АрендаторыGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите арендатора для удаления", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)АрендаторыGrid.SelectedItem;
            int id_арендатора = (int)row["id_арендатора"];

            if (MessageBox.Show("Вы уверены, что хотите удалить выбранного арендатора?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = "DELETE FROM Арендаторы WHERE id_арендатора = @id_арендатора";
                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_арендатора", id_арендатора);

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Арендатор успешно удален", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                            data();
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении арендатора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void ДобавитьДоговор_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new ДоговорРедактор();
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO ДоговорыАренды 
                                        (id_недвижимости, id_арендатора, ДатаНачала, ДатаОкончания, 
                                         ЕжемесячнаяПлата, Залог, Условия)
                                        VALUES (@id_недвижимости, @id_арендатора, @ДатаНачала, @ДатаОкончания, 
                                                @ЕжемесячнаяПлата, @Залог, @Условия)";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_недвижимости", dialog.id_недвижимости);
                        command.Parameters.AddWithValue("@id_арендатора", dialog.id_арендатора);
                        command.Parameters.AddWithValue("@ДатаНачала", dialog.ДатаНачала);
                        command.Parameters.AddWithValue("@ДатаОкончания", dialog.ДатаОкончания);
                        command.Parameters.AddWithValue("@ЕжемесячнаяПлата", dialog.ЕжемесячнаяПлата);
                        command.Parameters.AddWithValue("@Залог", dialog.Залог);
                        command.Parameters.AddWithValue("@Условия", (object)dialog.Условия ?? DBNull.Value);

                        connection.Open();
                        command.ExecuteNonQuery();

                        // Обновляем статус недвижимости на "Арендована"
                        query = "UPDATE Недвижимость SET id_статуса = 2 WHERE id_недвижимости = @id_недвижимости";
                        command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_недвижимости", dialog.id_недвижимости);
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при добавлении договора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void РедактироватьДоговор_Click(object sender, RoutedEventArgs e)
        {
            if (ДоговорыGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите договор для редактирования", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)ДоговорыGrid.SelectedItem;
            int id_договора = (int)row["id_договора"];

            var dialog = new ДоговорРедактор(id_договора);
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE ДоговорыАренды 
                                        SET id_недвижимости = @id_недвижимости, 
                                            id_арендатора = @id_арендатора, 
                                            ДатаНачала = @ДатаНачала, 
                                            ДатаОкончания = @ДатаОкончания, 
                                            ЕжемесячнаяПлата = @ЕжемесячнаяПлата, 
                                            Залог = @Залог, 
                                            Условия = @Условия
                                        WHERE id_договора = @id_договора";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_договора", id_договора);
                        command.Parameters.AddWithValue("@id_недвижимости", dialog.id_недвижимости);
                        command.Parameters.AddWithValue("@id_арендатора", dialog.id_арендатора);
                        command.Parameters.AddWithValue("@ДатаНачала", dialog.ДатаНачала);
                        command.Parameters.AddWithValue("@ДатаОкончания", dialog.ДатаОкончания);
                        command.Parameters.AddWithValue("@ЕжемесячнаяПлата", dialog.ЕжемесячнаяПлата);
                        command.Parameters.AddWithValue("@Залог", dialog.Залог);
                        command.Parameters.AddWithValue("@Условия", (object)dialog.Условия ?? DBNull.Value);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при обновлении договора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void УдалитьДоговор_Click(object sender, RoutedEventArgs e)
        {
            if (ДоговорыGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите договор для удаления", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)ДоговорыGrid.SelectedItem;
            int id_договора = (int)row["id_договора"];
            int id_недвижимости = ПолучитьIdНедвижимостиПоДоговору(id_договора);

            if (MessageBox.Show("Вы уверены, что хотите удалить выбранный договор?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        // Удаляем договор
                        string query = "DELETE FROM ДоговорыАренды WHERE id_договора = @id_договора";
                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_договора", id_договора);
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            // Обновляем статус недвижимости на "Свободна"
                            query = "UPDATE Недвижимость SET id_статуса = 1 WHERE id_недвижимости = @id_недвижимости";
                            command = new SqlCommand(query, connection);
                            command.Parameters.AddWithValue("@id_недвижимости", id_недвижимости);
                            command.ExecuteNonQuery();

                            MessageBox.Show("Договор успешно удален", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                            data();
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении договора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }
        private int ПолучитьIdНедвижимостиПоДоговору(int id_договора)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT id_недвижимости FROM ДоговорыАренды WHERE id_договора = @id_договора";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@id_договора", id_договора);

                connection.Open();
                return (int)command.ExecuteScalar();
            }
        }

        private void ДобавитьПлатеж_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new ПлатежРедактор();
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Платежи 
                                        (id_договора, ДатаПлатежа, Сумма, id_типа, id_статуса, Описание)
                                        VALUES (@id_договора, @ДатаПлатежа, @Сумма, @id_типа, @id_статуса, @Описание)";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_договора", dialog.id_договора);
                        command.Parameters.AddWithValue("@ДатаПлатежа", dialog.ДатаПлатежа);
                        command.Parameters.AddWithValue("@Сумма", dialog.Сумма);
                        command.Parameters.AddWithValue("@id_типа", dialog.id_типа);
                        command.Parameters.AddWithValue("@id_статуса", dialog.id_статуса);
                        command.Parameters.AddWithValue("@Описание", (object)dialog.Описание ?? DBNull.Value);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при добавлении платежа: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void РедактироватьПлатеж_Click(object sender, RoutedEventArgs e)
        {
            if (ПлатежиGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите платеж для редактирования", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)ПлатежиGrid.SelectedItem;
            int id_платежа = (int)row["id_платежа"];

            var dialog = new ПлатежРедактор(id_платежа);
            if (dialog.ShowDialog() == true)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE Платежи 
                                        SET id_договора = @id_договора, 
                                            ДатаПлатежа = @ДатаПлатежа, 
                                            Сумма = @Сумма, 
                                            id_типа = @id_типа, 
                                            id_статуса = @id_статуса, 
                                            Описание = @Описание
                                        WHERE id_платежа = @id_платежа";

                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_платежа", id_платежа);
                        command.Parameters.AddWithValue("@id_договора", dialog.id_договора);
                        command.Parameters.AddWithValue("@ДатаПлатежа", dialog.ДатаПлатежа);
                        command.Parameters.AddWithValue("@Сумма", dialog.Сумма);
                        command.Parameters.AddWithValue("@id_типа", dialog.id_типа);
                        command.Parameters.AddWithValue("@id_статуса", dialog.id_статуса);
                        command.Parameters.AddWithValue("@Описание", (object)dialog.Описание ?? DBNull.Value);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }

                    data();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при обновлении платежа: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void УдалитьПлатеж_Click(object sender, RoutedEventArgs e)
        {
            if (ПлатежиGrid.SelectedItem == null)
            {
                MessageBox.Show("Выберите платеж для удаления", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DataRowView row = (DataRowView)ПлатежиGrid.SelectedItem;
            int id_платежа = (int)row["id_платежа"];

            if (MessageBox.Show("Вы уверены, что хотите удалить выбранный платеж?", "Подтверждение",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string query = "DELETE FROM Платежи WHERE id_платежа = @id_платежа";
                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@id_платежа", id_платежа);

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Платеж успешно удален", "Успех", MessageBoxButton.OK, MessageBoxImage.Information);
                            data();
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка при удалении платежа: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }

        }
    }
}
   

