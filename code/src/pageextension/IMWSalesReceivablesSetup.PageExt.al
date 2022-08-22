pageextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("IMW Auto Assigned Customer Discount Group")
            {
                Caption = 'Auto Assign Customer Disc. Group';
                field("IMW Auto Assign Cust.Disc.Gr."; Rec."IMW AA Cust. Disc. Gr.")
                {
                    Caption = 'Enable AA Customer Disc. Group';
                    ApplicationArea = All;
                    ToolTip = 'Turn on/turn of - Enable Auto Assigned Customer Disc. Group Functionality.';
                }
                field("IWM Turnover Period"; Rec."IMW Turnover Period")
                {
                    Caption = 'Turnover Threshold Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies Time Range For turnover Threshold Period.';
                }
                field("IWM Validity Period"; Rec."IMW Period Of Validity")
                {
                    Caption = 'Validity Period Of Auto Assign';
                    ApplicationArea = All;
                    ToolTip = 'Specifies Validity Period Of Auto Assign.';
                }
                field("IMW Status"; Rec."IMW AA Status")
                {
                    Caption = 'Status Of Auto Assign Disc. Group Setup';
                    ApplicationArea = All;
                    ToolTip = 'Status of Auto Assign Disc. Group Setup Page.';
                    Editable = false;
                }
            }
        }
    }
}