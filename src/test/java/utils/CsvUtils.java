package utils;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;


public class CsvUtils {
    private static final Logger logger = Logger.getLogger(CsvUtils.class.getName());
   private static final String CSV_FILE_PATH = System.getProperty("user.dir") + File.separator + "src" + File.separator +
           "test" + File.separator + "java" + File.separator +
           "updateDate" + File.separator ;

    public static String csvUpdate(String csvUpdate, int rowIndex, String newDueDate) {

        String phatCsv = CSV_FILE_PATH + csvUpdate;
        List<String[]> csvData = readCsv(phatCsv);
        updateDueDate(csvData, rowIndex, newDueDate);
        writeCsv(phatCsv, csvData);
        String dueDate = getDueDate(phatCsv, rowIndex);
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
            logger.warning("Error al leer el archivo CSV");
            e.printStackTrace();
        }
        return csvData;
    }


    private static void updateDueDate(List<String[]> csvData, int rowIndex, String newDueDate) {

        if (rowIndex <= 0 || rowIndex >= csvData.size()) {
            logger.warning("El índice proporcionado no se encuentra en archivo CSV.");
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
            logger.info("CSV actualizado correctamente.");

        } catch (IOException e) {
            logger.warning("Error al escribir en el archivo CSV.");
            e.printStackTrace();
        }
    }

    public static String getDueDate(String filePath, int row) {
        List<String[]> csvData = readCsv(filePath);
        if (row >= 1 && row < csvData.size()) {
            String[] rowData = csvData.get(row);
            return  rowData[9];
        } else {
            logger.warning("Fila fuera de rango.");
            return null;
        }
    }


}
