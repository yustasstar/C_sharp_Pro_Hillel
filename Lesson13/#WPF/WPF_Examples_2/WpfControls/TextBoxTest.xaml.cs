using System.Windows;

namespace ClassicControls
{
	/// <summary>
	/// Interaction logic for TextBoxTest.xaml
	/// </summary>

	public partial class TextBoxTest : System.Windows.Window
	{

		public TextBoxTest()
		{
			InitializeComponent();
		}

		private void txt_SelectionChanged(object sender, RoutedEventArgs e)
		{
			if (txtSelection == null) return;
			txtSelection.Text = String.Format(
				"Selection from {0} to {1} is \"{2}\"",
				txt.SelectionStart, txt.SelectionLength, txt.SelectedText);
		}
	}
}