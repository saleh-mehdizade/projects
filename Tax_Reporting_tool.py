import tkinter as tk
from tkinter import filedialog
import pandas as pd
import openpyxl

df = None
df2 = None


def open_file():
    global df
    filepath = filedialog.askopenfilename()
    df = pd.read_excel(filepath, usecols="A, B")
    print(df)


def open_file2():
    global df2
    filepath = filedialog.askopenfilename()
    df2 = pd.read_excel(filepath, usecols="H")
    print(df2)


def write_to_destination():
    global df
    global df2
    # get the entered isin and ap value
    isin = isin_entry.get()
    ap = ap_entry.get()
    print(isin)
    print(ap)
    destination = "C:\\Users\\z003883\\Desktop\\Yhtiötapahtumat 2023 - Bank Tasks.xlsx"
    # openpyxl's method to open the destination workbook
    wb = openpyxl.load_workbook(destination)
    sheet = wb.active
    # get the first empty row
    max_row = sheet.max_row
    # write the data in the destination sheet
    data = {'ISIN': isin, 'AP Tunnus': ap}
    entered_data = pd.DataFrame(data, index=[0])
    entered_data.to_excel(destination, sheet_name='Taul1', startrow=max_row + 1, index=False)
    df.to_excel(destination, sheet_name='Taul1', startrow=max_row + 1, index=False)
    df2.to_excel(destination, sheet_name='Taul1', startrow=max_row + 1, index=False, header=False)
    # save the workbook
    wb.save(destination)
    print("Data is written in the destination folder")


root = tk.Tk()
root.title("Automation App")

isin_label = tk.Label(root, text="Enter ISIN:")
isin_label.grid(row=0, column=0)

isin_entry = tk.Entry(root)
isin_entry.grid(row=0, column=1)

ap_label = tk.Label(root, text="Enter AP Tunnus:")
ap_label.grid(row=1, column=0)

ap_entry = tk.Entry(root)
ap_entry.grid(row=1, column=1)

open_file_button = tk.Button(root, text="Client List", command=open_file)
open_file_button.grid(row=2, column=0)

open_file_button2 = tk.Button(root, text="Cash Slip", command=open_file2)
open_file_button2.grid(row=2, column=1)

report_button = tk.Button(root, text="Report", command=write_to_destination)
report_button.grid(row=3, column=0)

root.mainloop()
