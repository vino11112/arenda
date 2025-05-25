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
    /// Логика взаимодействия для ПлатежРедактор.xaml
    /// </summary>
    public partial class ПлатежРедактор : Window
    {
        private string connectionString = "Server=DESKTOP-VVN5VCI\\SQLEXPRESS;Database=Аренда;Integrated Security=True";
        public int id_договора { get; private set; }
        public DateTime ДатаПлатежа { get; private set; }
        public decimal Сумма { get; private set; }
        public int id_типа { get; private set; }
        public int id_статуса { get; private set; }
        public string Описание { get; private set; }
        public ПлатежРедактор()
        {
            InitializeComponent();
            ЗагрузитьДоговоры();
            ЗагрузитьТипыПлатежей();
            ЗагрузитьСтатусыПлатежей();
            ДатаПлатежаPicker.SelectedDate = DateTime.Today;
        }
        public ПлатежРедактор(int id_платежа) : this()
        {
            Title = "Редактирование платежа";
            ЗагрузитьДанныеПлатежа(id_платежа);
           

        }

        private void ЗагрузитьДоговоры()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT д.id_договора, 
                                    'Договор №' + CAST(д.id_договора as nvarchar) + ' - ' + н.Адрес as Описание
                                    FROM ДоговорыАренды д
                                    JOIN Недвижимость н ON д.id_недвижимости = н.id_недвижимости";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    ДоговорCombo.ItemsSource = dt.DefaultView;
                    ДоговорCombo.DisplayMemberPath = "Описание";
                    ДоговорCombo.SelectedValuePath = "id_договора";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке договоров: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьТипыПлатежей()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT id_типа, НазваниеТипа FROM ТипыПлатежей";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    ТипПлатежаCombo.ItemsSource = dt.DefaultView;
                    ТипПлатежаCombo.DisplayMemberPath = "НазваниеТипа";
                    ТипПлатежаCombo.SelectedValuePath = "id_типа";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке типов платежей: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьСтатусыПлатежей()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT id_статуса, НазваниеСтатуса FROM СтатусыПлатежей";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    СтатусПлатежаCombo.ItemsSource = dt.DefaultView;
                    СтатусПлатежаCombo.DisplayMemberPath = "НазваниеСтатуса";
                    СтатусПлатежаCombo.SelectedValuePath = "id_статуса";
                    СтатусПлатежаCombo.SelectedValue = 2; // По умолчанию "Оплачен"
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке статусов платежей: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ЗагрузитьДанныеПлатежа(int id_платежа)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Платежи WHERE id_платежа = @id_платежа";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@id_платежа", id_платежа);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        ДоговорCombo.SelectedValue = reader["id_договора"];
                        ДатаПлатежаPicker.SelectedDate = (DateTime)reader["ДатаПлатежа"];
                        СуммаText.Text = reader["Сумма"].ToString();
                        ТипПлатежаCombo.SelectedValue = reader["id_типа"];
                        СтатусПлатежаCombo.SelectedValue = reader["id_статуса"];
                        ОписаниеText.Text = reader["Описание"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при загрузке данных платежа: {ex.Message}", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (ПроверитьВвод())
            {
                id_договора = (int)ДоговорCombo.SelectedValue;
                ДатаПлатежа = ДатаПлатежаPicker.SelectedDate.Value;
                Сумма = decimal.Parse(СуммаText.Text);
                id_типа = (int)ТипПлатежаCombo.SelectedValue;
                id_статуса = (int)СтатусПлатежаCombo.SelectedValue;
                Описание = ОписаниеText.Text;

                DialogResult = true;
                Close();
            }
        }

        private bool ПроверитьВвод()
        {
            if (ДоговорCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите договор", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!ДатаПлатежаPicker.SelectedDate.HasValue)
            {
                MessageBox.Show("Выберите дату платежа", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (!decimal.TryParse(СуммаText.Text, out decimal сумма) || сумма <= 0)
            {
                MessageBox.Show("Введите корректную сумму платежа", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (ТипПлатежаCombo.SelectedItem == null)
                  {
                MessageBox.Show("Выберите тип платежа", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            if (СтатусПлатежаCombo.SelectedItem == null)
            {
                MessageBox.Show("Выберите статус платежа", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
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
