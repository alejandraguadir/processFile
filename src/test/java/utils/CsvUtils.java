package utils;

import org.apache.commons.logging.Log;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

public class CsvUtils {
    private static final String CSV_FILE_PATH = "D:\\PruebaTecnica\\src\\test\\java\\UpdateDate\\recaudo.csv";

    public static void csvUpdate(String filePath, int rowIndex, String newDueDate) {
        List<String[]> csvData = readCsv(CSV_FILE_PATH);
        updateDueDate(csvData, rowIndex, newDueDate);
        writeCsv(CSV_FILE_PATH, csvData);

    }

    public static void assertUpdate(String filePath, int rowIndex) {
        getDueDate(CSV_FILE_PATH, rowIndex);
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
        // Verificar que el índice esté dentro de los límites
        if (rowIndex <= 0 || rowIndex >= csvData.size()) {
            System.out.println("El índice proporcionado no se encuentra en archivo CSV.");
            return;
        }

        String[] rowData = csvData.get(rowIndex);
        rowData[9] = newDueDate;
        System.out.println("Fila actualizada: " + Arrays.toString(rowData));
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
        List<String[]> csvData = readCsv(filePath);  // Leer el archivo CSV
        if (row >= 1 && row < csvData.size()) {  // Asegurarse de que la fila es válida
            String[] rowData = csvData.get(row);  // Obtener los datos de la fila
            return  rowData[9];  // Retornar la fecha de vencimiento (columna 9)
        } else {
            System.out.println("Fila fuera de rango.");
            return null;  // Si la fila no es válida
        }
    }

    // Método principal de prueba
    public static void main(String[] args) {

        String filePath = CSV_FILE_PATH;
        int rowToUpdate = 2;
        String newDueDate = "2024-12-31";


        csvUpdate(filePath, rowToUpdate, newDueDate);
    }
}
