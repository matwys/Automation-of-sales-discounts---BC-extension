page 50002 "IMW CDGA Change Log"
{
    ApplicationArea = All;
    Caption = 'CDGA Change Log';
    PageType = List;
    SourceTable = "IMW CDGA Change Log";
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
                field("Entry No."; Rec."Entry No.")
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
                field("Customer Disc. Group Code"; Rec."Customer Disc. Group Code")
                {
                    Caption = 'Customer Disc. Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Customer Disc. Group Code';
                }
                field("Method Of Find Group By"; "Method Of Find Group By")
                {
                    Caption = 'Method Of Find Group By';
                    ApplicationArea = All;
                    ToolTip = 'Method Of Find Group By';
                }
                field("CDGA Changed By"; GetUserName(Rec.SystemCreatedBy))
                {

                    Caption = 'CDGA Changed By';
                    ApplicationArea = All;
                    ToolTip = 'CDGA Changed By';
                }
                field("CDGA Changed Date"; Rec.SystemCreatedAt)
                {
                    Caption = 'CDGA Changed Date';
                    ApplicationArea = All;
                    ToolTip = 'CDGA Changed Date';
                }
            }
        }
    }

    local procedure GetUserName(Guid: Guid): Code[50]
    var
        User: Record User;
    begin
        if User.Get(Guid) then
            exit(User."User Name");
    end;
}