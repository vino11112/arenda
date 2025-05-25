using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
    /// Логика взаимодействия для АрендаторРедактор.xaml
    /// </summary>
    public partial class АрендаторРедактор : Window
    {
        private string connectionString = "Server=DESKTOP-VVN5VCI\\SQLEXPRESS;Database=Аренда;Integrated Security=True";
        public string Фамилия { get; private set; }
        public string Имя { get; private set; }
        public string Отчество { get; private set; }
        public string Телефон { get; private set; }
        public string ЭлектроннаяПочта { get; private set; }
        public string ПаспортныеДанные { get; private set; }

        public АрендаторРедактор()
        {
            InitializeComponent();
        }
        public АрендаторРедактор(int id_арендатора) : this()
        {
            Title = "Редактирование арендатора";
            ЗагрузитьДанныеАрендатора(id_арендатора);
        }

        private void ЗагрузитьДанныеАрендатора(int id_арендатора)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Арендаторы WHERE id_арендатора = @id_арендатора";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@id_арендатора", id_арендатора);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        ФамилияText.Text = reader["Фамилия"].ToString();
                        ИмяText.Text = reader["Имя"].ToString();
                        ОтчествоText.Text = reader["Отчество"].ToString();
                        ТелефонText.Text = reader["Телефон"].ToString();
                        EmailText.Text = reader["ЭлектроннаяПочта"].ToString();
                        ПаспортText.Text = reader["ПаспортныеДанные"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных арендатора: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (ПроверитьВвод())
            {
                Фамилия = ФамилияText.Text;
                Имя = ИмяText.Text;
                Отчество = ОтчествоText.Text;
                Телефон = ТелефонText.Text;
                ЭлектроннаяПочта = EmailText.Text;
                ПаспортныеДанные = ПаспортText.Text;

                DialogResult = true;
                Close();
            }
        }

        private bool ПроверитьВвод()
        {
            if (string.IsNullOrWhiteSpace(ФамилияText.Text))
            {
                MessageBox.Show("Введите фамилию", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (string.IsNullOrWhiteSpace(ИмяText.Text))
            {
                MessageBox.Show("Введите имя", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (string.IsNullOrWhiteSpace(ТелефонText.Text))
            {
                MessageBox.Show("Введите телефон", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (string.IsNullOrWhiteSpace(ПаспортText.Text))
            {
                MessageBox.Show("Введите паспортные данные", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
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
