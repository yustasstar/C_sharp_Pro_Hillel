﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ImageButton
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /*
         *      При обратной отправке данной страницы, ASP.NET выполняет  
            перечисленные ниже действия. 
            1. Воссоздает объект страницы и ее элементов управления на основе значений по 
            умолчанию (указанных в файле .aspx), в результате чего страница оказывается в 
            том же состоянии, в котором была, когда запрашивалась впервые. 
            2. Выполняет десериализацию информации о состоянии и обновляет все элементы 
            управления. В результате страница возвращается в состояние, в котором  
            находилась перед последней отправкой клиенту. 
            3. Напоследок производится настройка страницы в соответствии с отправленными 
            данными формы. Например, если пользователь ввел новый текст в текстовом поле 
            или же сделал новый выбор в окне списка, эта информация разместится в  
            коллекции Form и используется ASP.NET для постройки соответствующих элементов 
            управления. После этого страница отображает текущее состояние при ее  
            просмотре пользователем. 
            4. Теперь в действие вступает код обработки событий. ASP.NET генерирует  
            соответствующие события, и код может реагировать изменением страницы,  
            переходом на новую страницу или же выполнением какой-то другой операции. 
        */

        protected void imagebutton1_Click(object sender, ImageClickEventArgs e)
        {
            Label1.Text += "Вы нажали элемент управления ImageButton в точке: (" + e.X.ToString() + ", " + e.Y.ToString() + ")";
        }
    }
}
