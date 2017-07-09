Function Get-UserSelection {
param
(
	[string]$text,
	[string[]]$options
)

	$getUserSelectionFormSource = @'
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace SelectOption
{
    public class SelectOptionForm : Form
    {
        private Button btnOk;
        private Label lblSelectionDisplayText;

        private List<RadioButton> radioButtons = new List<RadioButton>();

        public string LabelText { get { return lblSelectionDisplayText.Text; } set { lblSelectionDisplayText.Text = value; } }
        public string[] Options { get; set; }
        public string SelectedOption { get; set; }

        public SelectOptionForm()
        {
            InitializeComponent();
        }

        public void UpdateUI()
        {
            if (Options == null || Options.Length == 0)
            {
                return;
            }

            radioButtons.Clear();

            SuspendLayout();
            int top = lblSelectionDisplayText.Top;
            foreach (string localPath in Options)
            {
                top += 25;

                RadioButton rbLocalPath = new RadioButton
                {
                    Anchor = AnchorStyles.Top | AnchorStyles.Right,
                    Text = localPath,
                    Left = lblSelectionDisplayText.Left,
                    Top = top,
                    Width = 674
                };

                radioButtons.Add(rbLocalPath);
            }

            Controls.AddRange(radioButtons.ToArray());

            Height = top + 100;
            btnOk.Top = top + 25;

            ResumeLayout(false);
            PerformLayout();
        }

        private void SetSelectedOption()
        {
            if (!radioButtons.Any(rb => rb.Checked))
            {
                MessageBox.Show("Please select an option");
                return;
            }

            SelectedOption = radioButtons.First(rb => rb.Checked).Text;
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnOk = new System.Windows.Forms.Button();
            this.lblSelectionDisplayText = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnOk
            // 
            this.btnOk.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOk.Location = new System.Drawing.Point(612, 39);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 0;
            this.btnOk.Text = "Ok";
            this.btnOk.UseVisualStyleBackColor = true;
            this.btnOk.Click += new System.EventHandler(this.BtnOk_Click);
            // 
            // lblSelectionDisplayText
            // 
            this.lblSelectionDisplayText.Location = new System.Drawing.Point(13, 13);
            this.lblSelectionDisplayText.Name = "lblSelectionDisplayText";
            this.lblSelectionDisplayText.Size = new System.Drawing.Size(674, 13);
            this.lblSelectionDisplayText.TabIndex = 1;
            this.lblSelectionDisplayText.Text = "Select from these available options:";
            // 
            // SelectOptionForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(699, 74);
            this.Controls.Add(this.lblSelectionDisplayText);
            this.Controls.Add(this.btnOk);
            this.Name = "SelectOptionForm";
            this.Text = "Select from these available options";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SelectOptionForm_FormClosing);
            this.ResumeLayout(false);
        }

        #endregion

        private void BtnOk_Click(object sender, System.EventArgs e)
        {
            SetSelectedOption();
            Close();
        }

        private void SelectOptionForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!radioButtons.Any(rb => rb.Checked))
            {
                e.Cancel = true;
                MessageBox.Show("Please select an option");
                return;
            }

            SetSelectedOption();
        }
    }
}
'@

	Add-Type -TypeDefinition $getUserSelectionFormSource -ReferencedAssemblies System.Windows.Forms, System.Linq, System.Core, System.Drawing
	$getUserSelectionForm = New-Object 'SelectOption.SelectOptionForm'
	$getUserSelectionForm.LabelText = $text
    $getUserSelectionForm.Options = $options
	$getUserSelectionForm.UpdateUI()
	$result = $getUserSelectionForm.ShowDialog()

	Return $getUserSelectionForm.SelectedOption
}