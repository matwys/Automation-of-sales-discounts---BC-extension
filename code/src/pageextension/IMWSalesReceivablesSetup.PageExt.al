pageextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("IMW CDG Automation")
            {
                Caption = 'CDG Automation';
                field("IMW CDGA Enabled"; Rec."IMW CDGA Enabled")
                {
                    Caption = 'CDGA Enabled';
                    ApplicationArea = All;
                    ToolTip = 'Turn on/turn of - Enable CDGA Functionality.';
                }
                field("IWM CDGA Sales Period"; Rec."IMW CDGA Sales Period")
                {
                    Caption = 'CDGA Sales Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies CDGA Sales Period.';
                }
                field("IMW CDGA Validity Period"; Rec."IMW CDGA Validity Period")
                {
                    Caption = 'CDGA Validity Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies CDGA Validity Period.';
                }
                field("IMW CDGA Threshold Setup Status"; Rec."IMW CDGA Treshold Setup Status")
                {
                    Caption = 'CDGA Threshold Setup Status';
                    ApplicationArea = All;
                    ToolTip = 'CDGA Threshold Setup Status';
                    Editable = false;
                }
            }
        }
    }
}