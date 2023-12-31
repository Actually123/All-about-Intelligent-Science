## 代码构成
### ① rnn.py 
- `def weights_init(m)`

  目的：用于对线性层进行权重初始化，采用均匀分布 $U(-w_{\text{bound}}, w_{\text{bound}})$ 的方式对权重进行初始化，偏置初始化为0。  
  在模型初始化时调用这个函数。
- ```class word_embedding(nn.Module)```
  
  目的：用于定义词嵌入层，在初始化时，通过均匀分布 $U(-1, 1)$ 随机初始化词嵌入矩阵，并创建一个Embedding层，  
  在前向传播中，将输出的词索引转换成词嵌入向量。
  - `def __init__(self, vocab_length, embedding_dim)`
  - `def forward(self, input_sentence)`
- ```class RNN_model(nn.Mudule)```
  
  目的：定义整个循环神经网络模型
  - `def __init__(self, batch_sz, vocab_len, word_embedding, embedding_dim, lstm_hidden_dim)`  
  目的：初始化词嵌入层、LSTM层、全连接层、激活函数（LogSoftmax）并调用`weights_init(m)`
  - `def forward(self, sentence, is_test=False)`  
  目的：前向传播中，通过词嵌入层将输入的句子转换成词嵌入表示，然后输入LSTM层，最后通过全连接层和
  LogSoftmax激活函数得到模型的输出。若`is_test=True`，返回模型的最后一个预测值，否则返回模型的所有输出。
### ② main.py
- `def process_poems1(file_name)`  
  目的：将诗歌文本处理成数字形式，以便后续预测
- `def generate_batch(batch_size, poems_vec, word_to_int)`  
  目的：生成批处理数据的函数，为模型的训练提供输入和相应目标的输出
- `def run_training()`  
  目的：训练的循环，用于训练LSTM模型，生成诗歌文本
- `def to_word(predict, vocabs)`  
  目的：将预测的结果转化为汉字
- `def pretty_print_poem(poem)`  
  目的：令打印的结果更加工整
- `def gen_poem(begin_word)`  
  目的：基于预训练的LSTM模型，根据指定的开始字生成一句诗歌
