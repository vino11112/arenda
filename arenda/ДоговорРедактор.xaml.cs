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
using System.Windows.Shapes;

namespace arenda
{
    /// <summary>
    /// Логика взаимодействия для ДоговорРедактор.xaml
    /// </summary>
    public partial class ДоговорРедактор : Window
    {
        private string connectionString = "Server=DESKTOP-VVN5VCI\\SQLEXPRESS;Database=Аренда;Integrated Security=True";
        public int id_недвижимости { get; private set; }
        public int id_арендатора { get; private set; }
        public DateTime ДатаНачала { get; private set; }
        public DateTime ДатаОкончания { get; private set; }
        public decimal ЕжемесячнаяПлата { get; private set; }
        public decimal Залог { get; private set; }
        public string Условия { get; private set; }

        public ДоговорРедактор()
        {
            InitializeComponent();
            ЗагрузитьСвободнуюНедвижимость();
            ЗагрузитьАрендаторов();
            ДатаНачалаPicker.SelectedDate = DateTime.Today;
            ДатаОкончанияPicker.SelectedDate = DateTime.Today.AddYears(1);
        }
        public ДоговорРедактор(int id_договора) : this()
        {
            Title = "Редактирование договора";
            ЗагрузитьДанныеДоговора(id_договора);
        }

        private void ЗагрузитьСвободнуюНедвижимость()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT н.id_недвижимости, н.Адрес 
                                    FROM Недвижимость н
                                    JOIN СтатусыНедвижимости с ON н.id_статуса = с.id_статуса
                                    WHERE с.НазваниеСтатуса = 'Свободна'";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    НедвижимостьCombo.ItemsSource = dt.DefaultView;
                    НедвижимостьCombo.DisplayMemberPath = "Адрес";
                    НедвижимостьCombo.SelectedValuePath = "id_недвижимости";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьАрендаторов()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT id_арендатора, Фамилия + ' ' + Имя + ' ' + ISNULL(Отчество, '') as ФИО 
                                    FROM Арендаторы";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    АрендаторCombo.ItemsSource = dt.DefaultView;
                    АрендаторCombo.DisplayMemberPath = "ФИО";
                    АрендаторCombo.SelectedValuePath = "id_арендатора";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке арендаторов: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьДанныеДоговора(int id_договора)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM ДоговорыАренды WHERE id_договора = @id_договора";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@id_договора", id_договора);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        НедвижимостьCombo.SelectedValue = reader["id_недвижимости"];
                        АрендаторCombo.SelectedValue = reader["id_арендатора"];
                        ДатаНачалаPicker.SelectedDate = (DateTime)reader["ДатаНачала"];
                        ДатаОкончанияPicker.SelectedDate = (DateTime)reader["ДатаОкончания"];
                        ПлатаText.Text = reader["ЕжемесячнаяПлата"].ToString();
                        ЗалогText.Text = reader["Залог"].ToString();
                        УсловияText.Text = reader["Условия"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных договора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (ПроверитьВвод())
            {
                id_недвижимости = (int)НедвижимостьCombo.SelectedValue;
                id_арендатора = (int)АрендаторCombo.SelectedValue;
                ДатаНачала = ДатаНачалаPicker.SelectedDate.Value;
                ДатаОкончания = ДатаОкончанияPicker.SelectedDate.Value;
                ЕжемесячнаяПлата = decimal.Parse(ПлатаText.Text);
                Залог = decimal.Parse(ЗалогText.Text);
                Условия = УсловияText.Text;

                DialogResult = true;
                Close();
            }
        }

        private bool ПроверитьВвод()
        {
            if (НедвижимостьCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите недвижимость", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (АрендаторCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите арендатора", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!ДатаНачалаPicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Выберите дату начала", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!ДатаОкончанияPicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Выберите дату окончания", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (ДатаОкончанияPicker.SelectedDate <= ДатаНачалаPicker.SelectedDate)
            {
                MessageBox.Show("Дата окончания должна быть позже даты начала", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!decimal.TryParse(ПлатаText.Text, out decimal плата) || плата <= 0)
            {
                MessageBox.Show("Введите корректную сумму ежемесячной платы", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!decimal.TryParse(ЗалогText.Text, out decimal залог) || залог < 0)
            {
                MessageBox.Show("Введите корректную сумму залога", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            return true;
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}
