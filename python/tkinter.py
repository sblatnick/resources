from tkinter import *
from tkinter import ttk

#The tkinter package (“Tk interface”) is the standard Python interface to the Tcl/Tk GUI toolkit.
#Docs: https://docs.python.org/3/library/tkinter.html

root = Tk()
frm = ttk.Frame(root, padding=10)
frm.grid()
ttk.Label(frm, text="Hello World!").grid(column=0, row=0)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)
root.mainloop()

