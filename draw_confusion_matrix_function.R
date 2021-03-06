draw_confusion_matrix <- function(cm, classnum) {
  if (classnum > 3){
    print("function only supports 2 or 3 class models")
  }else{
    total <- sum(cm$table)
    res <- as.numeric(cm$table)
    
    # Generate color gradients. Palettes come from RColorBrewer.
    greenPalette <- c("#F7FCF5","#E5F5E0","#C7E9C0","#A1D99B","#74C476","#41AB5D","#238B45","#006D2C","#00441B")
    redPalette <- c("#FFF5F0","#FEE0D2","#FCBBA1","#FC9272","#FB6A4A","#EF3B2C","#CB181D","#A50F15","#67000D")
    getColor <- function (greenOrRed = "green", amount = 0) {
      if (amount == 0)
        return("#FFFFFF")
      palette <- greenPalette
      if (greenOrRed == "red")
        palette <- redPalette
      colorRampPalette(palette)(100)[10 + ceiling(90 * amount / total)]
    }
    
    if (classnum == 2){
      # set the basic layout
      layout(matrix(c(1,1,2)))
      par(mar=c(2,2,2,2))
      plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
      title('CONFUSION MATRIX', cex.main=2)
      
      # create the matrix 
      classes = colnames(cm$table)
      rect(150, 430, 240, 370, col=getColor("green", res[1]))
      text(195, 435, classes[1], cex=1.2)
      rect(250, 430, 340, 370, col=getColor("red", res[3]))
      text(295, 435, classes[2], cex=1.2)
      text(125, 370, 'Predicted', cex=1.3, srt=90, font=2)
      text(245, 450, 'Actual', cex=1.3, font=2)
      rect(150, 305, 240, 365, col=getColor("red", res[2]))
      rect(250, 305, 340, 365, col=getColor("green", res[4]))
      text(140, 400, classes[1], cex=1.2, srt=90)
      text(140, 335, classes[2], cex=1.2, srt=90)
      
      # add in the cm results
      text(195, 400, res[1], cex=1.6, font=2, col='white')
      text(195, 335, res[2], cex=1.6, font=2, col='white')
      text(295, 400, res[3], cex=1.6, font=2, col='white')
      text(295, 335, res[4], cex=1.6, font=2, col='white')
      
      # add in the specifics 
      plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = "DETAILS", xaxt='n', yaxt='n')
      text(10, 85, names(cm$byClass[1]), cex=1.2, font=2)
      text(10, 70, round(as.numeric(cm$byClass[1]), 3), cex=1.2)
      text(30, 85, names(cm$byClass[2]), cex=1.2, font=2)
      text(30, 70, round(as.numeric(cm$byClass[2]), 3), cex=1.2)
      text(50, 85, names(cm$byClass[5]), cex=1.2, font=2)
      text(50, 70, round(as.numeric(cm$byClass[5]), 3), cex=1.2)
      text(70, 85, names(cm$byClass[6]), cex=1.2, font=2)
      text(70, 70, round(as.numeric(cm$byClass[6]), 3), cex=1.2)
      text(90, 85, names(cm$byClass[7]), cex=1.2, font=2)
      text(90, 70, round(as.numeric(cm$byClass[7]), 3), cex=1.2)
      
      # add in the accuracy information 
      text(30, 35, names(cm$overall[1]), cex=1.5, font=2)
      text(30, 20, round(as.numeric(cm$overall[1]), 3), cex=1.4)
      text(70, 35, names(cm$overall[2]), cex=1.5, font=2)
      text(70, 20, round(as.numeric(cm$overall[2]), 3), cex=1.4)
    }
    
    if (classnum == 3) {
      # set the basic layout
      layout(matrix(c(1,1,2)))
      par(mar=c(2,2,2,2))
      plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
      title('CONFUSION MATRIX', cex.main=2)
      
      # create the matrix 
      classes = colnames(cm$table)
      rect(140, 435, 190, 395, col=getColor("green", res[1]))
      text(165, 440, classes[1], cex=1.2)
      rect(200, 435, 250, 395, col=getColor("red", res[4]))
      text(225, 440, classes[2], cex=1.2)
      rect(260, 435, 310, 395, col=getColor("red", res[7]))
      text(285, 440, classes[3], cex=1.2)
      text(120, 370, 'Predicted', cex=1.3, srt=90, font=2)
      text(225, 450, 'Actual', cex=1.3, font=2)
      
      rect(140, 390, 190, 350, col=getColor("red", res[2]))
      rect(200, 390, 250, 350, col=getColor("green", res[5]))
      rect(260, 390, 310, 350, col=getColor("red", res[8]))
      
      rect(140, 345, 190, 305, col=getColor("red", res[3]))
      rect(200, 345, 250, 305, col=getColor("red", res[6]))
      rect(260, 345, 310, 305, col=getColor("green", res[9]))
      
      text(135, 415, classes[1], cex=1.2, srt=90)
      text(135, 370, classes[2], cex=1.2, srt=90)
      text(135, 325, classes[3], cex=1.2, srt=90)
      
      # add in the cm results
      # row 1:
      text(165, 415, res[1], cex=1.6, font=2, col='white')
      text(225, 415, res[4], cex=1.6, font=2, col='white')
      text(285, 415, res[7], cex=1.6, font=2, col='white')
      
      # row 2:
      text(165, 370, res[2], cex=1.6, font=2, col='white')
      text(225, 370, res[5], cex=1.6, font=2, col='white')
      text(285, 370, res[8], cex=1.6, font=2, col='white')
      
      # row 3:
      text(165, 325, res[3], cex=1.6, font=2, col='white')
      text(225, 325, res[6], cex=1.6, font=2, col='white')
      text(285, 325, res[9], cex=1.6, font=2, col='white')
      
      # add in the specifics 
      plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = "DETAILS", xaxt='n', yaxt='n')
      text(10, 85, names(cm.party$byClass[,1][1]), cex=1.2, font=2)
      # list statistics:
      text(5, 70, paste0(names(cm$byClass[1,][1]), ":"), cex=1.1)
      text(15, 70, round(as.numeric(cm$byClass[1,][1]), 3), cex=1.1)
      text(5, 55, paste0(names(cm$byClass[1,][2]), ":"), cex=1.1)
      text(15, 55, round(as.numeric(cm$byClass[1,][2]), 3), cex=1.1)
      text(5, 40, paste0(names(cm$byClass[1,][5]), ":"), cex=1.1)
      text(15, 40, round(as.numeric(cm$byClass[1,][5]), 3), cex=1.1)
      text(5, 25, paste0(names(cm$byClass[1,][6]), ":"), cex=1.1)
      text(15, 25, round(as.numeric(cm$byClass[1,][6]), 3), cex=1.1)
      text(5, 10, paste0(names(cm$byClass[1,][7]), ":"), cex=1.1)
      text(15, 10, round(as.numeric(cm$byClass[1,][7]), 3), cex=1.1)
      
      
      text(35, 85, names(cm.party$byClass[,1][2]), cex=1.2, font=2)
      # list statistics:
      text(30, 70, paste0(names(cm$byClass[2,][1]), ":"), cex=1.1)
      text(40, 70, round(as.numeric(cm$byClass[2,][1]), 3), cex=1.1)
      text(30, 55, paste0(names(cm$byClass[2,][2]), ":"), cex=1.1)
      text(40, 55, round(as.numeric(cm$byClass[2,][2]), 3), cex=1.1)
      text(30, 40, paste0(names(cm$byClass[2,][5]), ":"), cex=1.1)
      text(40, 40, round(as.numeric(cm$byClass[2,][5]), 3), cex=1.1)
      text(30, 25, paste0(names(cm$byClass[2,][6]), ":"), cex=1.1)
      text(40, 25, round(as.numeric(cm$byClass[2,][6]), 3), cex=1.1)
      text(30, 10, paste0(names(cm$byClass[2,][7]), ":"), cex=1.1)
      text(40, 10, round(as.numeric(cm$byClass[2,][7]), 3), cex=1.1)
      
      
      text(60, 85, names(cm.party$byClass[,1][3]), cex=1.2, font=2)
      # list statistics:
      text(55, 70, paste0(names(cm$byClass[3,][1]), ":"), cex=1.1)
      text(65, 70, round(as.numeric(cm$byClass[3,][1]), 3), cex=1.1)
      text(55, 55, paste0(names(cm$byClass[3,][2]), ":"), cex=1.1)
      text(65, 55, round(as.numeric(cm$byClass[3,][2]), 3), cex=1.1)
      text(55, 40, paste0(names(cm$byClass[3,][5]), ":"), cex=1.1)
      text(65, 40, round(as.numeric(cm$byClass[3,][5]), 3), cex=1.1)
      text(55, 25, paste0(names(cm$byClass[3,][6]), ":"), cex=1.1)
      text(65, 25, round(as.numeric(cm$byClass[3,][6]), 3), cex=1.1)
      text(55, 10, paste0(names(cm$byClass[3,][7]), ":"), cex=1.1)
      text(65, 10, round(as.numeric(cm$byClass[3,][7]), 3), cex=1.1)
      
      # add in the accuracy information 
      text(85, 65, paste0(names(cm$overall[1]), ":"), cex=1.3, font=2)
      text(95, 65, round(as.numeric(cm$overall[1]), 3), cex=1.3, font=2)
      text(85, 45, paste0(names(cm$overall[2]), ":"), cex=1.3, font=2)
      text(95, 45, round(as.numeric(cm$overall[2]), 3), cex=1.3, font=2)
      
      
    }
    
  }

}
