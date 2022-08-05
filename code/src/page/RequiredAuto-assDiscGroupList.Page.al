page 50001 "IMW Req.Auto-assDisc.Gr.List"
{
    PageType = List;
    Caption = 'Requirements Auto-ass Disc. Group Page';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IMW Req. Auto-ass Disc. Group.";

    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Required"; Rec."Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a requirement for the customer discount group.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}