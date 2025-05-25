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
    /// Логика взаимодействия для НедвижимостьРедактор.xaml
    /// </summary>
    public partial class НедвижимостьРедактор : Window
    {
        private string connectionString = "Server=DESKTOP-VVN5VCI\\SQLEXPRESS;Database=Аренда;Integrated Security=True";
        public int id_владельца { get; private set; }
        public int id_типа { get; private set; }
        public string Адрес { get; private set; }
        public decimal Площадь { get; private set; }
        public int КоличествоКомнат { get; private set; }
        public int? Этаж { get; private set; }
        public string Описание { get; private set; }
        public decimal Цена { get; private set; }
        public НедвижимостьРедактор()
        {
            InitializeComponent();
            vlad();
            type();
        }
        public НедвижимостьРедактор(int id_недвижимости) : this()
        {
            Title = "Редактирование недвивижимости";
            ЗагрузитьДанныеНедвижимости(id_недвижимости);
        }
        private void vlad()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT id_владельца, Фамилия + ' ' + Имя + ' ' + ISNULL(Отчество, '') as ФИО FROM Владельцы";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    ВладелецCombo.ItemsSource = dt.DefaultView;
                    ВладелецCombo.DisplayMemberPath = "ФИО";
                    ВладелецCombo.SelectedValuePath = "id_владельца";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке владельцев: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void type()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT id_типа, НазваниеТипа FROM ТипыНедвижимости";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    ТипCombo.ItemsSource = dt.DefaultView;
                    ТипCombo.DisplayMemberPath = "НазваниеТипа";
                    ТипCombo.SelectedValuePath = "id_типа";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке типов недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьДанныеНедвижимости(int id_недвижимости)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Недвижимость WHERE id_недвижимости = @id_недвижимости";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@id_недвижимости", id_недвижимости);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        ВладелецCombo.SelectedValue = reader["id_владельца"];
                        ТипCombo.SelectedValue = reader["id_типа"];
                        АдресText.Text = reader["Адрес"].ToString();
                        ПлощадьText.Text = reader["Площадь"].ToString();
                        КомнатыText.Text = reader["КоличествоКомнат"].ToString();
                        ЭтажText.Text = reader["Этаж"] != DBNull.Value ? reader["Этаж"].ToString() : "";
                        ОписаниеText.Text = reader["Описание"].ToString();
                        ЦенаText.Text = reader["Цена"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных недвижимости: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (ПроверитьВвод())
            {
                id_владельца = (int)ВладелецCombo.SelectedValue;
                id_типа = (int)ТипCombo.SelectedValue;
                Адрес = АдресText.Text;
                Площадь = decimal.Parse(ПлощадьText.Text);
                КоличествоКомнат = int.Parse(КомнатыText.Text);
                Этаж = !string.IsNullOrEmpty(ЭтажText.Text) ? (int?)int.Parse(ЭтажText.Text) : null;
                Описание = ОписаниеText.Text;
                Цена = decimal.Parse(ЦенаText.Text);

                DialogResult = true;
                Close();
            }
        }

        private bool ПроверитьВвод()
        {
            if (ВладелецCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите владельца", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (ТипCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите тип недвижимости", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (string.IsNullOrWhiteSpace(АдресText.Text))
            {
                MessageBox.Show("Введите адрес", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!decimal.TryParse(ПлощадьText.Text, out decimal площадь) || площадь <= 0)
            {
                MessageBox.Show("Введите корректную площадь", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!int.TryParse(КомнатыText.Text, out int комнаты) || комнаты < 0)
            {
                MessageBox.Show("Введите корректное количество комнат", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!string.IsNullOrEmpty(ЭтажText.Text) && !int.TryParse(ЭтажText.Text, out int этаж))
            {
                MessageBox.Show("Введите корректный этаж", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!decimal.TryParse(ЦенаText.Text, out decimal цена) || цена < 0)
            {
                MessageBox.Show("Введите корректную цену", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
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
