# Customer Disc. Group Automation (User)

## Auto assign Customer to discount group

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Customers**. Choose the related link.
2. Choose **Customer** from the list and open **Customer Card**.
3. When functionality is enable it should not be possible to manually manipulate with **Customer Disc. Group**.
4. You can use action to auto assign this Customer to discount group. Find action **CDGA Update Customer** (Related -> Prices and Discounts ->CDGA Update Customer) and run it.
5. See Customer is assigned to discount group and fields **Customer Disc. Group**, **CDGA Valid To**, **CDGA Changed By** and **CDGA Changed Date** have been changed.

> [!Note]
>
> New created Customer will be auto assigned to **Customer Disc. Group**.

## Create new Sales Document

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Sales Order**. Choose the related link.
2. Set Customer in **Customer Name** field. When Customer has invalid assigned this page show error. When Customer has valid assigned, all should work correctly.

> [!Note]
>
> When sales document is going to be created from action in **Customer Card** page. Error will show up when Customer has invalid assigned.
>
> All old document with customer with invalid assigned will work correctly.

## CDGA Change Log

### Search CDGA Change Log in tell me what you want to do

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **CDGA Change Log**. Choose the related link.
2. CDGA Change Log page show up.

### From Customer Card page

1. Choose the ![Tell me what you want to do](media/TellMe.png) icon. Enter **Customers**. Choose the related link.
2. Choose **Customer** from the list and open **Customer Card**.
3. Find action **CDGA Change Log** (Related -> History -> CDGA Change Log) and run it.
4. CDGA Change Log page show up. List is filtered by *Customer No.*.
