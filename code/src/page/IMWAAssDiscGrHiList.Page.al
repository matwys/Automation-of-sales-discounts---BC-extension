page 50002 "IMW A. Ass. Disc. Gr. Hi. List"
{
    ApplicationArea = All;
    Caption = 'Auto Assign To Customer Disc. Group History';
    PageType = List;
    SourceTable = "IMW Auto. Ass. Disc. Gr. Hist.";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(History)
            {
                Caption = 'History';
                field("No."; Rec."No.")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'Entry No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field("Cust. Disc. Group Code"; Rec."Cust. Disc. Group Code")
                {
                    Caption = 'Customer Disc. Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Customer Disc. Group Code';
                }
                field("IMW Last Auto. Ass. Ch. By"; Rec."IMW Last Auto. Ass. Ch. By")
                {
                    Caption = 'Last Auto Assign To Disc. Group Changed By';
                    ApplicationArea = All;
                    ToolTip = 'Last Auto Assign To Discount Group Changed By';
                }
                field("IMW Last Auto Ass. Ch. Date"; Rec."IMW Last Auto Ass. Ch. Date")
                {
                    Caption = 'Last Auto Assign To Disc. Group Changed Date';
                    ApplicationArea = All;
                    ToolTip = 'Last Date Of Auto Assigned To Discount Group Changed';
                }
            }
        }
    }
}