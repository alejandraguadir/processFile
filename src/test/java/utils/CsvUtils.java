package utils;



import java.io.*;
import java.util.ArrayList;

import java.util.List;


public class CsvUtils {
   private static final String CSV_FILE_PATH = System.getProperty("user.dir") + File.separator + "src" + File.separator +
           "test" + File.separator + "java" + File.separator +
           "UpdateDate" + File.separator + "recaudo.csv";
    public static String csvUpdate(String filePath, int rowIndex, String newDueDate) {
        List<String[]> csvData = readCsv(CSV_FILE_PATH);
        updateDueDate(csvData, rowIndex, newDueDate);
        writeCsv(CSV_FILE_PATH, csvData);
        String dueDate = getDueDate(CSV_FILE_PATH, rowIndex);
        return dueDate;
    }


    // Método para leer el archivo CSV
    private static List<String[]> readCsv(String filePath) {
        List<String[]> csvData = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] columns = line.split(";");
                csvData.add(columns);
            }
        } catch (IOException e) {
            System.out.println("Error al leer el archivo CSV.");
            e.printStackTrace();
        }
        return csvData;
    }


    private static void updateDueDate(List<String[]> csvData, int rowIndex, String newDueDate) {

        if (rowIndex <= 0 || rowIndex >= csvData.size()) {
            System.out.println("El índice proporcionado no se encuentra en archivo CSV.");
            return;
        }

        String[] rowData = csvData.get(rowIndex);
        String sanitizedDate = newDueDate.replace("'", "");
        rowData[9] = sanitizedDate;

    }


    // Método para escribir en archivo CSV
    private static void writeCsv(String filePath, List<String[]> csvData) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (String[] row : csvData) {
                bw.write(String.join(";", row));
                bw.newLine();
            }
            System.out.println("CSV actualizado correctamente.");
        } catch (IOException e) {
            System.out.println("Error al escribir en el archivo CSV.");
            e.printStackTrace();
        }
    }

    public static String getDueDate(String filePath, int row) {
        List<String[]> csvData = readCsv(filePath);
        if (row >= 1 && row < csvData.size()) {
            String[] rowData = csvData.get(row);
            return  rowData[9];
        } else {
            System.out.println("Fila fuera de rango.");
            return null;
        }
    }


}
